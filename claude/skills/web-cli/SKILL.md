---
name: web-cli
description: |
  Web browser CLI tool for testing and verifying web pages during development.

  USE WHEN:
  - You need to verify functionality of a web page or app you're building
  - You need to test a web endpoint, check build status, or validate UI output
  - You need to interact with a running web application (login, fill forms, navigate)
  - The user asks to scrape, fetch, screenshot, or interact with any URL
  - You are building features and need to confirm they work in the browser

  This is the GO-TO TOOL for verifying web functionality. Prefer `web` over WebFetch
  for any page that uses JavaScript, LiveView, or requires session state.
---

# Web Browser Tool

You have the ability to browse the web with a full browser via the system shell.

**Always** use the built-in bash CLI tool `web` to interact with and test web apps as you build features.
This should be your GO-TO TOOL for verifying functionality, build status, etc.

## Basic Usage

```bash
web <url> [options]
```

By default the page is converted to markdown and displayed to stdout:

```bash
web example.com
web localhost:4000/dashboard
```

You can redirect output to a file:

```bash
web example.com --raw > output.html
web example.com --raw > output.json
```

**Never** pass `--raw` or `--truncate-after` unless the user asks, or if it makes sense (e.g., fetching JSON from an API).

## Options

| Option | Description |
|--------|-------------|
| `--raw` | Output raw HTML/JSON instead of markdown |
| `--truncate-after <n>` | Truncate after n characters (default: 100000) |
| `--screenshot <path>` | Save screenshot to filepath |
| `--profile <name>` | Use named session profile (default: "default") |
| `--js <code>` | Execute JavaScript after page loads |
| `--form <id>` | Target form by ID for submission |
| `--input <name>` | Field name to fill (repeatable) |
| `--value <value>` | Value for preceding `--input` |
| `--after-submit <url>` | URL to load after form submission |

## Session Persistence

Each invocation of `web` uses a **shared session** — cookie sessions and other state are preserved across separate invocations. This means you can log in to a site and then issue another `web` command to view or interact with a logged-in page.

Use the optional `--profile` argument to browse under unique profiles, which is useful for testing multiple logins or sessions:

```bash
web http://localhost:4000 --profile "user1"
web http://localhost:4000 --profile "user2"
```

## Common Patterns

### Verify a Page Works
```bash
web localhost:4000/users
```

### Authenticated Session
```bash
# 1. Login and establish session
web localhost:4000/login \
  --form login_form \
  --input email --value user@example.com \
  --input password --value secret \
  --profile app_session

# 2. Access protected pages with same session
web localhost:4000/dashboard --profile app_session
```

### Screenshot for Visual Verification
```bash
web localhost:4000/dashboard --screenshot /tmp/dashboard.png
```

### Fetch JSON from an API
```bash
web localhost:4000/api/health --raw
```

### Execute JavaScript After Load
```bash
web localhost:4000 --js "document.querySelector('button').click()"
```

### LiveView Form Submission
```bash
web localhost:4000/users/new \
  --form user_form \
  --input "user[name]" --value "John Doe" \
  --input "user[email]" --value "john@example.com"
```

### Navigate After Form Submit
```bash
web localhost:4000/login \
  --form login_form \
  --input email --value admin@test.com \
  --input password --value password123 \
  --after-submit localhost:4000/admin/dashboard
```

## Key Capabilities

- **JavaScript rendering**: Unlike simple HTTP fetches, `web` renders JavaScript — essential for SPAs, Phoenix LiveView, React/Vue/Angular apps
- **Phoenix LiveView support**: Automatically handles `.phx-connected` state waiting, form submissions with loading states
- **Session persistence**: Cookies and state preserved across invocations via shared or named profiles

## When to Use `web` vs Other Tools

| Scenario | Tool |
|----------|------|
| Simple static page (no JS) | WebFetch |
| JavaScript-rendered content | `web` |
| Form submission needed | `web` |
| Screenshot required | `web` |
| Session persistence needed | `web` |
| Phoenix LiveView app | `web` |
| Verifying feature during dev | `web` |
