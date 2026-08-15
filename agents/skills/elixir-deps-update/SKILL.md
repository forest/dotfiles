---
name: elixir-deps-update
description: Update this project's Hex dependencies and open a PR documenting every version change.
disable-model-invocation: true
metadata:
  forked-from: https://github.com/zorn/dotfiles
  forked-skill: elixir-deps-update
  forked-on: "2026-08-15"
---

# Update Elixir Dependencies & Open a PR

Update this project's outdated Hex dependencies — all of them by default, or all
but a set the user opts out of — verify with `mix precommit`, then open a pull
request whose body documents every direct and transitive version change with a
`diff.hex.pm` link, a version-anchored changelog link, and inlined changelog
highlights.

## Requirements

- `gh` CLI, authenticated, with access to this repo
- Elixir/`mix` project with a `precommit` alias
- `python3`, `curl`, `jq`

## Workflow

### 1. Preflight — clean tree, fresh branch

Confirm `git status` is clean. If there are uncommitted changes, stop and ask
the user how to proceed — don't fold unrelated work into a dependency PR.

Get onto an up-to-date base and cut a branch named for the update — packages
when few, otherwise the date:

```bash
git checkout main && git pull
git checkout -b deps/update-$(date +%Y-%m-%d)
```

**Done when:** on a new branch off up-to-date `main` with a clean tree.

### 2. Identify outdated dependencies

```bash
mix hex.outdated
```

Read the output and split it into:

- **Safe** — only the patch or minor version changed (no major bump)
- **Breaking** — the major version changed (e.g. `1.x` → `2.x`)

Present both lists to the user so they can see what's on the table.

**Done when:** every outdated package is classified safe or breaking and shown
to the user.

### 3. Choose what to update

The default is to update **everything**. Ask the user whether they want to opt
any packages out of this run; the default answer is none. Record the resulting
update set (all outdated packages minus any they skip).

**Done when:** there is an explicit update set and the user has had the chance to
exclude packages.

### 4. Apply the updates

- Taking the whole set: `mix deps.update --all`.
- Skipping some: list only the ones to take — `mix deps.update dep_a dep_b …`.
- For a **breaking** bump the user chose to take, first widen the constraint in
  `mix.exs` to allow the new major, then `mix deps.update <dep>`.

**Done when:** `mix.lock` reflects exactly the intended set and `mix deps.get`
runs clean.

### 5. Handle breaking changes

For each major bump taken, before moving to the next one:

1. Find the changelog or upgrade guide — try `https://hexdocs.pm/<pkg>/changelog.html`
   first, then the package root `https://hexdocs.pm/<pkg>` for a "Changelog",
   "Upgrade Guide", or "Migration Guide" link.
2. Apply the code changes the upgrade requires.
3. Run step 6 verification. Only advance once it's green.

**Done when:** every major bump taken has its code changes applied and verifies
clean.

### 6. Verify

```bash
mix precommit
```

Fix whatever it reports — formatting (`mix format`), compile warnings, failing
tests — and re-run until it exits 0.

**Done when:** `mix precommit` passes with no changes left to make.

### 7. Draft the PR body

Extract the actual version changes from the lock diff and classify them:

```bash
git diff main -- mix.lock \
  | python3 ~/.claude/skills/elixir-deps-update/scripts/parse_mix_lock_diff.py
```

This yields a JSON array holding one `{package, app, old_version, new_version,
status}` object per changed package. `package` is the Hex registry name — use
it to build the diff and hexdocs links. `app` is the lock's own key; it differs
from `package` only occasionally (see Notes). If the script warns on stderr
that lines look like Hex entries but didn't parse, stop and fix the script
rather than shipping a PR body that silently omits those packages.

Classify each as **direct** (named in the `deps/0` function of `mix.exs`) or
**transitive** (everything else):

```bash
sed -n '/defp deps do/,/^  end/p' mix.exs | grep -oE '\{:[a-zA-Z0-9_]+' | sed 's/{://' | sort -u
```

For each changed package `<pkg>` going `<old>` → `<new>`:

- **Diff link** (always available, no fetch): `https://diff.hex.pm/diff/<pkg>/<old>..<new>`
- **Changelog link + highlights** — where a library publishes its changelog
  varies, so walk the lookup ladder in
  [reference/finding-changelogs.md](reference/finding-changelogs.md) (hexdocs
  changelog page → hexdocs sidebar → Hex-API source repo → GitHub changelog
  files → Releases → compare view). Include **both** a link to the changelog
  and inline highlights:
  - **Link:** point at the changelog you actually read, and deep-link to the
    release with a version anchor when the page has one (`…/changelog.html#<anchor>`).
    Derive and verify the anchor per that reference — don't guess. When the diff
    spans several releases (a minor bump crossing multiple versions), anchor to
    the newest/target version so the reader lands at the top of the range
    (changelogs are reverse-chronological).
  - **Highlights:** quote the authors' entries with light cleanup; never invent.
    Requalify anything GitHub will re-resolve against _this_ repo — a bare
    `#123` from an upstream changelog links to your own issue 123, and a bare
    `@handle` notifies an unrelated person. Rewrite issue references as
    `<owner>/<repo>#123` and strip `@handle` credits; see
    [reference/finding-changelogs.md](reference/finding-changelogs.md#quoting-safely-cross-repo-references).
    If the ladder runs out, drop the changelog link, say "no changelog found",
    and keep the diff link.

Assemble the body. Join the diff and changelog links with `·`; for one-line
transitive entries put both links and the note on the same line:

```markdown
## Summary

<1-2 sentences: dependency update, note if any breaking bumps needed code changes>

## Direct Dependencies

**<pkg>** `<old> → <new>`
[diff](https://diff.hex.pm/diff/<pkg>/<old>..<new>) · [changelog](<changelog-url>#<anchor>)

- changelog highlight
- changelog highlight

## Transitive Dependencies

**<pkg>** `<old> → <new>` — [diff](https://diff.hex.pm/diff/<pkg>/<old>..<new>) · [changelog](<changelog-url>#<anchor>) — <one-line note>
```

Omit a section entirely if it has no entries — no empty headers.

**Done when:** every package in the diff JSON has a diff link and either a
version-anchored changelog link with highlights, or an explicit "no changelog
found" note — and no quoted highlight carries a bare `#123` or `@handle`.

### 8. Commit and open the PR

Build a subject that **names the libraries updated**. Only a handful → name them
all (`update req, jason, phoenix_live_view`). A long list → name the prominent
ones and summarize the rest (`update phoenix, ecto, and 9 others`). Use the same
subject for the commit and the PR title.

Before pushing, scan the body file for references GitHub would resolve against
_this_ repo:

```bash
grep -nE '(^|[^A-Za-z0-9_./-])#[0-9]+' <path>        # bare issue/PR refs
grep -nE '(^|[^A-Za-z0-9_/-])@[A-Za-z0-9-]+' <path>  # bare @mentions
```

Qualified refs (`owner/repo#123`) don't match, so every hit is either a
verbatim upstream reference to fix or a deliberate pointer at this repo (a
"supersedes #192" in the summary is fine). Fix the former before pushing —
once the PR is open the bad links have already back-linked onto whatever issues
they hit.

```bash
git add -A
git commit -m "chore(deps): <subject>"
git push -u origin HEAD
gh pr create --title "chore(deps): <subject>" --body-file <path>
```

- Conventional-commit type + lowercase subject.
- Write the body to a real file and pass `--body-file` (not `--body -`).
- No `Co-Authored-By` trailer and no AI attribution anywhere in the commit or PR.

Report the PR URL back to the user.

## Notes

- Hex package names in `mix.lock` are usually the registry name, but the entry
  is `"app_name" => {:hex, :hex_name, ...}` and `diff.hex.pm` / hexdocs key off
  `hex_name`. They match in the vast majority of cases but occasionally differ.
  The parser returns `hex_name` as `package` and `app_name` as `app`, so build
  links from `package`.
- `mix.lock` entries use either `"app" => {:hex, ...}` or `"app": {:hex, ...}`
  depending on the Mix version that wrote them; the parser accepts both.
- If `mix hex.outdated` reports nothing outdated, tell the user and stop —
  don't cut a branch or open an empty PR.
