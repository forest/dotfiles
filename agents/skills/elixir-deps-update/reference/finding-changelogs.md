# Finding a package's changelog highlights

Where a library publishes its changelog varies. Walk this ladder for each
changed package `<pkg>` going `<old>` → `<new>`, stopping at the first source
that yields real entries. **Never invent highlights** — if the ladder runs out,
say "no changelog found" and link the diff.

## 1. hexdocs changelog page

Most Elixir libraries publish a changelog extra:

```
https://hexdocs.pm/<pkg>/changelog.html
```

## 2. hexdocs package root

If there's no `changelog.html`, load the package root and scan the sidebar /
extras for a link named "Changelog", "CHANGES", "Upgrade Guide", "Migration
Guide", "Upgrading", or "Breaking Changes":

```
https://hexdocs.pm/<pkg>
```

## 3. Source repo via the Hex API

Find the package's GitHub repo, then read its changelog directly:

```bash
curl -s "https://hex.pm/api/packages/<pkg>" \
  | jq -r '.meta.links | to_entries[] | select(.key | test("github"; "i")) | .value'
```

This usually returns `https://github.com/<owner>/<repo>`. From there, try the
raw changelog file on the default branch (fall back to `main` then `master`),
in order until one loads:

```
https://raw.githubusercontent.com/<owner>/<repo>/<branch>/CHANGELOG.md
https://raw.githubusercontent.com/<owner>/<repo>/<branch>/CHANGES.md
https://raw.githubusercontent.com/<owner>/<repo>/<branch>/CHANGELOG.markdown
```

## 4. GitHub Releases

If the repo keeps notes in Releases rather than a file:

```bash
gh api "repos/<owner>/<repo>/releases" --jq '.[] | {tag: .tag_name, body: .body}'
```

Match release tags in the range (tags are often `v<version>` or bare
`<version>`) and use their notes as the highlights.

## 5. Compare view (last resort)

If neither a changelog file nor matching releases exist, link a GitHub compare
view instead and note there was no changelog:

```
https://github.com/<owner>/<repo>/compare/v<old>...v<new>
```

Try without the `v` prefix if that 404s.

## Extracting the range

From whichever source, pull the entries for versions **after `<old>` up to and
including `<new>`**. Locate the version headers, take the bullet points under
each, and combine them into one highlight list for the package. Quote the
authors' wording with only light cleanup — these are factual technical
statements about what changed, not something to paraphrase.

## Quoting safely: cross-repo references

Changelog entries are written from inside the package's own repo, so their
references are relative to _that_ repo. Pasted verbatim into your PR body,
GitHub re-resolves them against **yours**:

- `#123` becomes a link to _your_ issue 123 — nearly always an unrelated real
  issue, and opening the PR back-links it onto that issue's timeline.
- `@handle` notifies a real GitHub user with no connection to your repo.
- A bare commit SHA autolinks and resolves to nothing.

Rewrite each issue reference into the qualified form `<owner>/<repo>#123` using
the package's repo — step 3 above yields it if you don't already have it. That
renders as a normal cross-repo link and lands where the author meant. If the
repo can't be established, drop the reference; the sentence reads fine without
it. Strip `@handle` credits outright — a thanks-to line tells the reader of a
dependency bump nothing.

This is easy to miss precisely because quoting faithfully is the rule
everywhere else in this step. Fidelity to the author's wording does not extend
to their link context.

## Linking to the release with a version anchor

The PR body links to the changelog you actually read. Deep-link to the release
with a version anchor whenever the page has one — don't guess the anchor,
**verify it against the rendered headings**. When the diff spans several
releases, anchor to the newest/target version; changelogs are
reverse-chronological, so the reader lands at the top of the range.

### hexdocs pages (`changelog.html`)

ex_doc emits an `id` on each version heading. Read the real ids rather than
constructing them:

```bash
curl -sL "https://hexdocs.pm/<pkg>/changelog.html" \
  | grep -oE '<h[12][^>]*id="[^"]*"' | grep -iE 'id="v?[0-9]'
```

The id is the heading text lowercased with each run of non-alphanumerics
collapsed to a single `-`. Headings vary, so the anchor does too:

- `1.8.9 (2026-07-07)` → `#1-8-9-2026-07-07`
- `v1.2.6 (2026-07-07)` → `#v1-2-6-2026-07-07` (some projects keep the `v`)
- `1.26.3` → `#1-26-3` (no date)

Note that `hexdocs.pm/<pkg>/changelog.html` 301-redirects to a
`<pkg>.hexdocs.pm/changelog.html` host; `curl -L` follows it. The canonical
`hexdocs.pm/...` form is fine to put in the PR body — it redirects in a browser.

### GitHub `CHANGELOG.md`

GitHub builds the anchor by lowercasing the heading, **removing** punctuation
(not converting it), then turning spaces into `-`. So dots vanish rather than
becoming hyphens:

- `## v1.0.4` → `#v104`
- `## v1.9.1` → `#v191`
- `## 0.6.0 (15 Apr 2026)` → `#060-15-apr-2026`
- `## v1.3.0 (2026-07-03)` → `#v130-2026-07-03` (date hyphens are kept)

Some common packages (e.g. `hpax`, `mint`, `websock_adapter`) ship a
`CHANGELOG.md` on GitHub but publish **no** `hexdocs.pm/<pkg>/changelog.html`
(it 404s) — link the GitHub file with its anchor in that case.
