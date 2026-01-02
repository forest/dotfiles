---
name: web-cli
description: |
  Portable web scraper CLI for LLMs with JavaScript rendering, form submission, and session persistence.

  USE WHEN user needs to scrape a URL, fill forms, take screenshots, or interact with web pages
  requiring JavaScript execution. Supports Phoenix LiveView applications natively.
---

# Web CLI Skill

## When to Activate This Skill

### Direct Web Scraping
- "scrape this URL with JavaScript"
- "fetch this page and render it"
- "get the page after JavaScript loads"
- "convert this page to markdown"

### Form Submission
- "fill out this form"
- "submit login credentials to this page"
- "enter values into form fields"
- "automate form submission"

### Screenshot Capture
- "take a screenshot of this page"
- "capture this webpage as an image"
- "screenshot after JavaScript loads"

### Session/Authentication
- "use my logged-in session"
- "maintain session across requests"
- "use a specific browser profile"

### LiveView/SPA Support
- "scrape this Phoenix LiveView app"
- "interact with this dynamic page"
- "wait for JavaScript to load"

## Tool: `web`

```
web <url> [options]
```

### Core Options

| Option | Description |
|--------|-------------|
| `--raw` | Output raw HTML instead of markdown |
| `--truncate-after <n>` | Truncate after n characters (default: 100000) |
| `--screenshot <path>` | Save screenshot to filepath |
| `--profile <name>` | Use named session profile (default: "default") |
| `--js <code>` | Execute JavaScript after page loads |

### Form Submission Options

| Option | Description |
|--------|-------------|
| `--form <id>` | Target form by ID |
| `--input <name>` | Field name to fill (repeatable) |
| `--value <value>` | Value for preceding `--input` |
| `--after-submit <url>` | URL to load after form submission |

## Key Features

### JavaScript Rendering
Unlike simple HTTP fetches, `web` renders JavaScript. Essential for:
- Single Page Applications (SPAs)
- Phoenix LiveView pages
- React/Vue/Angular apps
- Pages with dynamic content loading

### Phoenix LiveView Support
Automatically handles:
- `.phx-connected` state waiting
- Form submissions with loading states
- State management between interactions

### Session Persistence
The `--profile` option maintains cookies and session state across requests:
```bash
# Login once
web localhost:4000/login --form login_form \
  --input email --value user@example.com \
  --input password --value secret \
  --profile myapp

# Subsequent requests use same session
web localhost:4000/dashboard --profile myapp
```

## Usage Examples

### Basic Page Fetch
```bash
web https://example.com
```

### Screenshot with Truncated Output
```bash
web https://example.com --screenshot page.png --truncate-after 5000
```

### Form Login
```bash
web localhost:4000/login \
  --form login_form \
  --input email --value test@example.com \
  --input password --value secret
```

### Execute JavaScript
```bash
web https://example.com --js "document.querySelector('button').click()"
```

### Navigate After Form Submit
```bash
web localhost:4000/login \
  --form login_form \
  --input email --value admin@test.com \
  --input password --value password123 \
  --after-submit localhost:4000/admin/dashboard
```

## When to Use `web` vs Other Tools

| Scenario | Tool |
|----------|------|
| Simple static page | WebFetch |
| JavaScript-rendered content | `web` |
| Form submission needed | `web` |
| Screenshot required | `web` |
| Session persistence needed | `web` |
| Bot detection bypass needed | brightdata skill |
| Phoenix LiveView app | `web` |

## Integration with Other Skills

- **brightdata**: If `web` fails due to bot detection, escalate to brightdata skill
- **WebFetch**: Use for simple static pages (faster, no JS overhead)

## Common Patterns

### Authenticated Scraping Session
```bash
# 1. Login and establish session
web localhost:4000/login \
  --form login_form \
  --input email --value user@example.com \
  --input password --value secret \
  --profile app_session

# 2. Access protected pages
web localhost:4000/protected/data --profile app_session
```

### Capture State After Interaction
```bash
# Click a button and capture result
web https://app.example.com \
  --js "document.querySelector('#load-more').click(); await new Promise(r => setTimeout(r, 2000));" \
  --screenshot after-click.png
```

### LiveView Form Submission
```bash
# Phoenix LiveView forms work seamlessly
web localhost:4000/users/new \
  --form user_form \
  --input "user[name]" --value "John Doe" \
  --input "user[email]" --value "john@example.com"
```

---

**Last Updated:** 2025-01-02
