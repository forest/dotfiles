#!/usr/bin/env python3
"""
Parse a git/gh diff and extract mix.lock dependency version changes.

Usage:
    gh pr diff <pr-url> | python3 parse_mix_lock_diff.py
    git diff main -- mix.lock | python3 parse_mix_lock_diff.py
    python3 parse_mix_lock_diff.py path/to/diff.txt

Output: JSON list of {package, app, old_version, new_version, status}
where status is one of "bumped", "added", "removed".

`package` is the Hex registry name - the one diff.hex.pm and hexdocs key
off, so it is the one to build links from. `app` is the lock's own key
(the OTP application name). They match for the vast majority of packages;
the field is kept separate for the ones where they don't.

Only reports packages whose version actually changed - unchanged
mix.lock entries (e.g. lines reformatted by `mix deps.get` without a
version change) are skipped.

Anything that looks like a Hex lock entry but doesn't parse is reported
on stderr rather than dropped, so a future mix.lock format change fails
loudly instead of masquerading as "no dependencies changed".
"""

import json
import re
import sys

# Matches a mix.lock entry line. Mix has emitted two separator styles over
# time and both are still in the wild, so accept either:
#   -  "earmark" => {:hex, :earmark, "1.4.48", "f2d4...", [:mix], [], "hexpm", "..."},
#   +  "earmark": {:hex, :earmark, "1.4.49", "a1b2...", [:mix], [], "hexpm", "..."},
LOCK_LINE_RE = re.compile(
    r'^([+-])\s*"([^"]+)"\s*(?:=>|:)\s*\{:hex,\s*:([\w.]+),\s*"([^"]+)"'
)

# A changed line that claims to be a Hex entry. Used to catch entries the
# parser fails to understand instead of silently skipping them.
HEX_ENTRY_HINT_RE = re.compile(r"^[+-].*\{:hex,")


def extract_mix_lock_hunk(diff_text: str) -> str:
    """Pull out only the lines belonging to the mix.lock file diff."""
    out = []
    in_mix_lock = False
    saw_file_header = False
    for line in diff_text.splitlines():
        if line.startswith("diff --git"):
            saw_file_header = True
            in_mix_lock = line.rstrip().endswith("mix.lock") or " b/mix.lock" in line
            continue
        if in_mix_lock:
            out.append(line)

    # A bare `git diff -- mix.lock` still carries a `diff --git` header, but a
    # hand-trimmed hunk pasted in by itself may not. Fall back to treating the
    # whole input as the hunk rather than returning nothing.
    if not saw_file_header:
        return diff_text
    return "\n".join(out)


def parse_changes(diff_text: str):
    old_versions = {}
    new_versions = {}
    hex_names = {}
    unparsed = []

    for line in diff_text.splitlines():
        # Skip the diff metadata lines (+++ / --- headers) which also start with +/-
        if line.startswith("+++") or line.startswith("---"):
            continue
        m = LOCK_LINE_RE.match(line)
        if not m:
            if HEX_ENTRY_HINT_RE.match(line):
                unparsed.append(line.strip())
            continue
        sign, app, hex_name, version = m.groups()
        hex_names[app] = hex_name
        if sign == "-":
            old_versions[app] = version
        else:
            new_versions[app] = version

    changes = []
    all_apps = sorted(set(old_versions) | set(new_versions))
    for app in all_apps:
        old = old_versions.get(app)
        new = new_versions.get(app)
        if old and new and old != new:
            status = "bumped"
        elif old and not new:
            status = "removed"
        elif new and not old:
            status = "added"
        else:
            continue  # version unchanged, just reformatted - not a real change
        changes.append(
            {
                "package": hex_names.get(app, app),
                "app": app,
                "old_version": old,
                "new_version": new,
                "status": status,
            }
        )
    return changes, unparsed


def main():
    if len(sys.argv) > 1:
        with open(sys.argv[1], "r") as f:
            diff_text = f.read()
    else:
        diff_text = sys.stdin.read()

    mix_lock_hunk = extract_mix_lock_hunk(diff_text)
    changes, unparsed = parse_changes(mix_lock_hunk)

    if unparsed:
        print(
            f"warning: {len(unparsed)} changed line(s) look like Hex lock entries "
            "but did not parse - the mix.lock format may have changed:",
            file=sys.stderr,
        )
        for line in unparsed[:5]:
            print(f"  {line[:120]}", file=sys.stderr)
        if len(unparsed) > 5:
            print(f"  ... and {len(unparsed) - 5} more", file=sys.stderr)

    if not changes and not unparsed and mix_lock_hunk.strip():
        print("note: no mix.lock version changes found in the diff.", file=sys.stderr)

    print(json.dumps(changes, indent=2))


if __name__ == "__main__":
    main()
