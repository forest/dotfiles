---
name: code-research
description: Research open-source repositories to understand how something is built or works.
metadata:
  author: morph
  version: "0.1.0"
  argument-hint: <question about an external repo>
---

# Code Research

Use `github_codebase_search` to explore external open-source repositories and understand their implementation details.

## When To Use

- The user asks how an open-source library or framework implements something.
- You need to understand an external dependency's internals before integrating with it.
- The user wants to compare how different repos solve a problem.
- You need to find usage examples or patterns in a public GitHub repo.

## Steps

1. Identify the GitHub repository (e.g. `vercel/next.js`, `facebook/react`).
2. Break the user's question into multiple focused search angles (e.g. entry points, data flow, config, tests).
3. Fire multiple `github_codebase_search` calls **in parallel** — one per angle. Do not run them sequentially.
4. Read and cross-reference the returned files/sections from all queries.
5. Summarize findings with concrete file paths and code references.

## Parallel Queries

Always decompose the research into 2-4 concurrent searches. For example, to understand how a repo handles authentication:

- Query 1: "Find the authentication middleware and session handling"
- Query 2: "Find the login/signup API routes and handlers"
- Query 3: "Find the auth configuration and token validation"

Run all queries at the same time to minimize latency.

## Query Template

"Find how <repo> implements <feature>. Include entry points, key functions, and data flow."
