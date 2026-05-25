---
name: code-edit
description: Use Fast Apply (edit_file) for precise edits without reading full files.
metadata:
  author: morph
  version: "0.1.0"
  argument-hint: <file-or-change>
---

# Code Edit

Prefer `edit_file` for modifications. Minimize full-file reads.

## When To Use

- The user requests code changes.
- You can target specific files/functions.
- You need to avoid context pollution.

## Steps

1. Locate the target file(s) (WarpGrep if needed).
2. Read the smallest necessary snippet(s).
3. Use `edit_file` with minimal context and `// ... existing code ...` placeholders.
4. Re-run relevant checks (tests/build/lint) if available.

## Notes

- Keep edits small and surgical.
- Prefer adding one change per call.
