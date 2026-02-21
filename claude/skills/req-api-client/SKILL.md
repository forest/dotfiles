---
name: req-api-client
description: Use when building an HTTP API client, SDK wrapper, or service integration module in Elixir using the Req library. Triggers on "API client", "SDK", "service wrapper", "HTTP integration", "webhook", "Req plugin", or when creating modules that call external APIs.
---

# Building API Clients (SDKs) with Req

## Overview

Build "Small Development Kits" — minimal, composable API wrappers using Req's plugin architecture instead of massive auto-generated SDKs. The core insight from Dashbit: **most apps use 2-3 API calls, not 400 modules**.

## When to Use

- Building a wrapper around any REST/HTTP API
- Creating a reusable service client (Stripe, S3, GitHub, etc.)
- Integrating with an external service that needs auth, retries, or custom headers
- Adding webhook signature verification

**When NOT to use:** If a well-maintained Elixir SDK already exists and covers your needs, use it.

## Core Pattern: The Module Wrapper

Every API client follows the same `new/request/request!` shape:

```elixir
defmodule MyApp.Stripe do
  @doc "Build a configured Req struct. Call with options to override defaults."
  def new(options \\ []) when is_list(options) do
    config = Application.fetch_env!(:my_app, :stripe)

    Req.new(
      base_url: "https://api.stripe.com/v1",
      auth: {:bearer, Keyword.fetch!(config, :api_key)},
      retry: :transient
    )
    |> Req.Request.append_request_steps(
      stripe_post: fn req ->
        # Stripe uses POST for writes — auto-convert GET with body
        with %{method: :get, body: <<_::binary>>} <- req do
          %{req | method: :post}
        end
      end
    )
    |> Req.merge(Keyword.get(config, :req_options, []) ++ options)
  end

  def request(url_or_opts, options \\ [])

  def request(url, options) when is_binary(url),
    do: Req.request(new([url: parse_url(url)] ++ options))

  def request(options, _) when is_list(options),
    do: Req.request(new(options))

  def request!(url_or_opts, options \\ [])

  def request!(url, options) when is_binary(url),
    do: Req.request!(new([url: parse_url(url)] ++ options))

  def request!(options, _) when is_list(options),
    do: Req.request!(new(options))

  # Smart URL routing via pattern matching on resource IDs
  defp parse_url("cus_" <> _ = id), do: "/customers/#{id}"
  defp parse_url("sub_" <> _ = id), do: "/subscriptions/#{id}"
  defp parse_url("/" <> _ = path), do: path
  defp parse_url(path), do: "/" <> path
end
```

### Key Principles

| Principle | Implementation |
|-----------|---------------|
| Config from app env | `Application.fetch_env!/2` in `new/1`, never hardcoded |
| Composable overrides | `Req.merge/2` as LAST call in `new/1` — callers override anything |
| `req_options` escape hatch | Config key for test/env-specific Req options (e.g., `plug:`) |
| Both `request` and `request!` | Bang variant for scripts/pipelines, tuple variant for app code |
| Internal `new/1` | Callers use `request/2`, never handle `%Req.Request{}` directly |

### The `Req.merge/2` Chain

**CRITICAL**: `Req.merge/2` must be the LAST call in `new/1`. It enables:

```elixir
# Override at call site
MyApp.Stripe.request!("cus_123", auth: {:bearer, other_token}, retry: false)

# Override from config (test plug, custom timeout, etc.)
# config/test.exs
config :my_app, :stripe,
  api_key: "sk_test_xxx",
  req_options: [plug: {Req.Test, MyApp.Stripe}]
```

### Convenience Functions: Start Small

The Dashbit philosophy is "start small." Begin with just `request/2` and `request!/2`. Add domain-specific convenience functions (`list_repos/2`, `create_issue/3`) only when you have repeated call patterns. Most apps use 2-3 endpoints — `request!/2` with URL strings is often enough:

```elixir
# Often sufficient — no convenience functions needed
MyApp.GitHub.request!("/users/octocat/repos")
MyApp.GitHub.request!(method: :post, url: "/repos/owner/repo/issues", json: %{title: "Bug"})
```

If you DO add convenience functions, keep them thin wrappers around `request/2`:

```elixir
def list_repos(username, options \\ []),
  do: request("/users/#{username}/repos", options)
```

## Plugin Architecture (Reusable Clients)

For clients used across multiple projects, use Req's `attach/2` plugin pattern:

```elixir
defmodule ReqGitHub do
  @doc "Attach GitHub API plugin to a Req request."
  def attach(%Req.Request{} = request, options \\ []) do
    request
    |> Req.Request.register_options([:github_token, :github_api_version])
    |> Req.Request.merge_options(options)
    |> Req.Request.append_request_steps(github_auth: &auth_step/1)
    |> Req.Request.prepend_response_steps(github_errors: &error_step/1)
  end

  defp auth_step(request) do
    token = Req.Request.get_option(request, :github_token)
    version = Req.Request.get_option(request, :github_api_version, "2022-11-28")

    request
    |> Req.Request.put_header("authorization", "Bearer #{token}")
    |> Req.Request.put_header("x-github-api-version", version)
    |> Req.Request.put_header("accept", "application/vnd.github+json")
  end

  defp error_step({request, %{status: status} = response}) when status >= 400 do
    message = get_in(response.body, ["message"]) || "HTTP #{status}"
    {request, %{response | body: %{"error" => message, "status" => status}}}
  end

  defp error_step(tuple), do: tuple
end
```

**Usage:**
```elixir
req = Req.new() |> ReqGitHub.attach(github_token: "ghp_xxx")
Req.get!(req, url: "https://api.github.com/user").body
```

### Plugin Conventions

1. **`attach/2`** takes `%Req.Request{}` + options, returns `%Req.Request{}`
2. **`register_options/2` first**, then `merge_options/2`, then add steps
3. **Append request steps** (run after Req's built-in steps)
4. **Prepend response steps** (run before Req's built-in decode)
5. **Name step keys** with your module prefix to avoid collisions
6. **Prefix private keys** with your project name (`req_` is reserved by Req)

### Step Lifecycle

```
Request Steps (sequential) → Adapter (HTTP call) → Response/Error Steps (sequential)
```

- Request step returns `request` → continues pipeline
- Request step returns `{request, response}` → **skips remaining request steps**, jumps to response steps
- Response step returns `{request, exception}` → switches to error steps
- Error step returns `{request, response}` → switches back to response steps

## Testing with Req.Test

### The Pattern: Plug-Based Stubs

**Never** use custom adapter mocks. Use `Req.Test.stub/2` with `plug: {Req.Test, Name}`:

```elixir
# config/test.exs — route requests to test plugs
config :my_app, :stripe,
  api_key: "sk_test_xxx",
  req_options: [plug: {Req.Test, MyApp.Stripe}]
```

```elixir
# test/my_app/stripe_test.exs
defmodule MyApp.StripeTest do
  use ExUnit.Case, async: true

  test "fetches a customer" do
    Req.Test.stub(MyApp.Stripe, fn conn ->
      assert conn.method == "GET"
      assert conn.request_path == "/v1/customers/cus_123"
      Req.Test.json(conn, %{"id" => "cus_123", "name" => "Test"})
    end)

    assert {:ok, %{status: 200, body: body}} = MyApp.Stripe.request("cus_123")
    assert body["name"] == "Test"
  end

  test "handles API errors" do
    Req.Test.stub(MyApp.Stripe, fn conn ->
      conn |> Plug.Conn.send_resp(402, Jason.encode!(%{"error" => "card_declined"}))
    end)

    assert {:ok, %{status: 402}} = MyApp.Stripe.request("cus_123")
  end
end
```

### Testing Expectations (Ordered)

```elixir
test "retries on transient failure then succeeds" do
  Req.Test.expect(MyApp.Stripe, &Req.Test.transport_error(&1, :econnrefused))
  Req.Test.expect(MyApp.Stripe, &Req.Test.json(&1, %{"ok" => true}))

  assert {:ok, %{body: %{"ok" => true}}} = MyApp.Stripe.request("/charges")
end
```

### Concurrent Tests with Allowances

When the request happens in a spawned process (GenServer, Task):

```elixir
test "async worker fetches data" do
  {:ok, worker} = start_worker()

  Req.Test.stub(MyApp.Stripe, fn conn ->
    Req.Test.json(conn, %{"balance" => 1000})
  end)

  # Allow the worker process to use this test's stubs
  Req.Test.allow(MyApp.Stripe, self(), worker)

  assert {:ok, 1000} = Worker.get_balance(worker)
end
```

### Response Helpers

| Helper | Use |
|--------|-----|
| `Req.Test.json(conn, data)` | JSON response with correct content-type |
| `Req.Test.html(conn, html)` | HTML response |
| `Req.Test.text(conn, text)` | Plain text response |
| `Req.Test.transport_error(conn, reason)` | Simulate `:timeout`, `:econnrefused`, etc. |
| `Req.Test.redirect(conn, to: path)` | Redirect response |

## Webhook Signature Verification

For APIs that push events via webhooks (Stripe, GitHub, etc.):

### 1. Preserve Raw Body

```elixir
defmodule MyAppWeb.Plugs.RawBody do
  @behaviour Plug.Parsers

  def init(opts), do: opts

  def parse(%{path_info: ["webhooks" | _]} = conn, _type, _subtype, _headers, opts) do
    {:ok, body, conn} = Plug.Conn.read_body(conn, opts)
    conn = Plug.Conn.put_private(conn, :raw_body, body)
    {:ok, %{}, conn}
  end

  def parse(conn, _type, _subtype, _headers, _opts) do
    {:next, conn}
  end
end
```

### 2. Verify Signature

```elixir
defmodule MyApp.Stripe.WebhookSignature do
  @valid_window_seconds 300

  def verify(payload, signature_header, secret) do
    with {:ok, timestamp, signatures} <- parse_header(signature_header),
         :ok <- check_freshness(timestamp),
         expected = compute_signature(timestamp, payload, secret),
         true <- Enum.any?(signatures, &Plug.Crypto.secure_compare(&1, expected)) do
      :ok
    else
      _ -> {:error, :invalid_signature}
    end
  end

  defp compute_signature(timestamp, payload, secret) do
    :crypto.mac(:hmac, :sha256, secret, "#{timestamp}.#{payload}")
    |> Base.encode16(case: :lower)
  end

  defp check_freshness(timestamp) do
    if System.system_time(:second) - timestamp <= @valid_window_seconds,
      do: :ok,
      else: {:error, :expired}
  end
end
```

### 3. Controller Plug

```elixir
defmodule MyAppWeb.StripeWebhookController do
  use MyAppWeb, :controller

  plug :verify_signature

  def handle(conn, %{"type" => type} = event) do
    # Process event...
    send_resp(conn, 200, "ok")
  end

  defp verify_signature(conn, _opts) do
    secret = Application.fetch_env!(:my_app, :stripe_webhook_secret)
    signature = Plug.Conn.get_req_header(conn, "stripe-signature") |> List.first()
    raw_body = conn.private[:raw_body]

    case MyApp.Stripe.WebhookSignature.verify(raw_body, signature, secret) do
      :ok -> conn
      {:error, _} -> conn |> send_resp(400, "invalid signature") |> halt()
    end
  end
end
```

## AWS/S3 Pattern

For AWS services, Req has built-in SigV4 signing:

```elixir
defmodule MyApp.S3 do
  def new(options \\ []) when is_list(options) do
    config = Application.fetch_env!(:my_app, :s3)

    Req.new(
      base_url: "#{Keyword.fetch!(config, :endpoint_url)}/#{Keyword.fetch!(config, :bucket)}",
      aws_sigv4: [service: :s3] ++ Keyword.take(config, [:access_key_id, :secret_access_key, :region]),
      retry: :transient
    )
    |> Req.merge(Keyword.get(config, :req_options, []) ++ options)
  end

  def put_object(key, body, options \\ []),
    do: Req.put(new([url: key, body: body] ++ options))

  def get_object(key, options \\ []),
    do: Req.get(new([url: key] ++ options))

  def request(options \\ []), do: Req.request(new(options))
  def request!(options \\ []), do: Req.request!(new(options))
end
```

## Quick Reference

### Module Wrapper Checklist

- [ ] `new/1` takes keyword options, returns `%Req.Request{}`
- [ ] Config from `Application.fetch_env!/2`, not function args
- [ ] `Req.merge/2` is LAST call in `new/1`
- [ ] Config supports `req_options` key for test overrides
- [ ] Both `request/2` and `request!/2` exposed
- [ ] Custom request steps for API-specific behavior
- [ ] Tests use `Req.Test.stub/2` + `plug: {Req.Test, Name}` in config

### Plugin Checklist

- [ ] `attach/2` takes `%Req.Request{}` + options
- [ ] `register_options/2` before `merge_options/2`
- [ ] Step keys prefixed with module name
- [ ] Request steps appended, response steps prepended

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Passing client struct to every function call | Use `new/1` internally in `request/2`. Callers never see `%Req.Request{}` |
| Hardcoding auth tokens as function arguments | Pull from `Application.fetch_env!/2` in `new/1` |
| Custom adapter mocks in tests | Use `Req.Test.stub/2` with `plug: {Req.Test, Name}` |
| `Req.merge/2` in the middle of `new/1` | ALWAYS make it the last call — enables caller overrides |
| Missing `req_options` config key | Required for `plug:` injection in test config |
| String interpolation for all URLs | Use `:path_params` for templated paths or pattern matching for ID routing |
| Only implementing `request!/2` | Provide both bang and tuple variants |
| Forgetting `retry: :transient` | Almost all API clients want transient retry |
| Writing response handling in each function | Use response steps for cross-cutting concerns |
| Skipping `register_options/2` in plugins | Req validates options — unregistered options raise errors |

## Sources

- [SDKs with Req: Stripe](https://dashbit.co/blog/sdks-with-req-stripe) — Dashbit
- [SDKs with Req: S3](https://dashbit.co/blog/sdks-with-req-s3) — Dashbit
- [Req hexdocs](https://hexdocs.pm/req) — Plugin, testing, and step architecture
