---
name: phoenix-liveview
description: Critical Phoenix LiveView guidelines that prevent common bugs, memory issues, and deprecated patterns. Use when writing LiveView modules, LiveView tests, or working with streams, navigation, forms, or JS hooks. Prevents memory ballooning from improper collection handling, deprecated function usage, and common test failures.
---

# Phoenix LiveView Guidelines

## Navigation

- **Never** use deprecated `live_redirect` or `live_patch`
- **Always** use:
  - Templates: `<.link navigate={href}>` and `<.link patch={href}>`
  - LiveViews: `push_navigate/2` and `push_patch/2`

## Module Naming & Routing

- Name LiveViews with `Live` suffix: `AppWeb.WeatherLive`
- Router's `:browser` scope is aliased with `AppWeb`, so use: `live "/weather", WeatherLive`

## LiveComponents

**Avoid LiveComponents** unless you have a strong, specific need. Prefer function components.

## JavaScript Hooks

- **Never** write embedded `<script>` tags in HEEx
- **Always** write scripts in `assets/js/` and integrate via `assets/js/app.js`
- When using `phx-hook="MyHook"` where the hook manages its own DOM, **must** also set `phx-update="ignore"`:

```heex
<div id="chart" phx-hook="ChartHook" phx-update="ignore"></div>
```

## Streams

**Always** use streams for collections to avoid memory ballooning:

```elixir
# Append items
stream(socket, :messages, [new_msg])

# Prepend items
stream(socket, :messages, [new_msg], at: -1)

# Reset with new items (for filtering)
stream(socket, :messages, messages, reset: true)

# Delete item
stream_delete(socket, :messages, msg)
```

**Never** use deprecated `phx-update="append"` or `phx-update="prepend"`.

### Stream Template Pattern

Parent must have `phx-update="stream"` and a DOM id. Children consume `@streams.name` with the stream-provided id:

```heex
<div id="messages" phx-update="stream">
  <div :for={{id, msg} <- @streams.messages} id={id}>
    {msg.text}
  </div>
</div>
```

### Streams Are Not Enumerable

Cannot use `Enum.filter/2`, `Enum.reject/2`, etc. on streams. To filter/refresh, **refetch and reset**:

```elixir
def handle_event("filter", %{"filter" => filter}, socket) do
  messages = list_messages(filter)
  {:noreply,
   socket
   |> assign(:messages_empty?, messages == [])
   |> stream(:messages, messages, reset: true)}
end
```

### Stream Empty States

Streams don't support counting. Track count separately. For empty states, use Tailwind:

```heex
<div id="tasks" phx-update="stream">
  <div class="hidden only:block">No tasks yet</div>
  <div :for={{id, task} <- @streams.tasks} id={id}>
    {task.name}
  </div>
</div>
```

## Form Handling

**Always** use `to_form/2` and access via `@form`:

```elixir
# From params
def handle_event("submitted", params, socket) do
  {:noreply, assign(socket, form: to_form(params))}
end

# From changeset
%User{} |> Ecto.Changeset.change() |> to_form()
```

```heex
<.form for={@form} id="todo-form" phx-change="validate" phx-submit="save">
  <.input field={@form[:field]} type="text" />
</.form>
```

**Never do this:**
```heex
<%!-- FORBIDDEN: accessing changeset directly --%>
<.form for={@changeset}>
<.form let={f}>
```

- **Never** pass changeset directly to template
- **Never** use `<.form let={f} ...>` syntax
- **Always** give forms unique DOM IDs

## LiveView Tests

- Use `Phoenix.LiveViewTest` and `LazyHTML` for assertions
- Use `render_submit/2` and `render_change/2` for form tests
- **Always** reference element IDs from templates in tests
- **Never** test against raw HTML; use `element/2`, `has_element?/2`:

```elixir
assert has_element?(view, "#my-form")
```

- Test for element presence rather than text content
- Focus on outcomes, not implementation details

### Debugging Test Failures

```elixir
html = render(view)
document = LazyHTML.from_fragment(html)
matches = LazyHTML.filter(document, "your-selector")
IO.inspect(matches, label: "Matches")
```
