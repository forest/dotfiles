# Git Commits & Pull Requests

## Attribution

- No promotional, attribution, or co-authorship content in any git artifact — commit messages, PR titles, PR summaries, or any other version-control record.
- No `Co-Authored-By:` trailers. No "Generated with [Tool]" footers. No AI tool branding, badges, or signatures.
- Commits and PRs are attributed solely to the human author running the session.

## PR summary style

Governs PR summaries specifically, not writing in general.

- Length doesn't buy closer reading — it buys skimming. Keep summaries tight enough that what's written is what gets read.
- Lead with the outcome: what happened or what was found. Supporting detail comes after, for whoever wants it.
- Keep caveats short; spend the bulk of the summary on the actual answer.
- Be selective about what to include rather than compressing into fragments or stacked bullets — readability beats terseness. Reserve lists for genuinely discrete items, tables for short enumerable facts.
- One idea per sentence, in the spirit of ASD-STE100: short sentences, active voice, present tense, minimal subordinate clauses. One term per concept.
- Don't cut the reasoning to save space — keep the clause that carries the why.

## Conventional Commits

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Formatting, no code change |
| `refactor` | Code change, no fix or feature |
| `perf` | Performance improvement |
| `test` | Adding/fixing tests |
| `chore` | Maintenance, deps, tooling |
| `ci` | CI/CD changes |

**Examples:**

```bash
git commit -m "feat(schema): add validation for email fields"
git commit -m "fix: resolve timeout in async operations"
git commit -m "feat!: breaking change to API"
```

Do not modify `CHANGELOG.md` in normal PRs. Release notes are generated from Git history during release, so keep changes focused on proper Conventional Commits.
