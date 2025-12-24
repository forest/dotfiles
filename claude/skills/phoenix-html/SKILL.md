---
name: phoenix-html
description: Critical Phoenix HTML and HEEx template guidelines that prevent common bugs and syntax errors. Use when writing Phoenix templates, HEEx files, LiveView templates, or any code using `~H` sigils. Prevents common mistakes with form handling, conditional syntax, class attributes, interpolation, and template comments that cause compilation errors or runtime bugs.
---

# Phoenix HTML/HEEx Guidelines

## Template Syntax

- **Always** use `~H` sigils or `.html.heex` files. **Never** use `~E`
- HEEx comments use `<%!-- comment --%>` syntax

## Forms

- **Always** use `Phoenix.Component.form/1` and `Phoenix.Component.inputs_for/1`
- **Never** use deprecated `Phoenix.HTML.form_for` or `Phoenix.HTML.inputs_for`
- **Always** use `to_form/2` for form handling:

```elixir
# In mount/handle_event:
assign(socket, form: to_form(changeset))

# In template:
<.form for={@form} id="product-form">
  <.input field={@form[:name]} />
</.form>
```

- **Always** add unique DOM IDs to forms for testability

## Conditionals

Elixir has `if/else` but **does NOT support** `if/else if` or `if/elsif`.

**Never do this (invalid):**
```heex
<%= if condition do %>
  ...
<% else if other_condition %>
  ...
<% end %>
```

**Always use `cond` for multiple conditions:**
```heex
<%= cond do %>
  <% condition1 -> %>
    ...
  <% condition2 -> %>
    ...
  <% true -> %>
    ...
<% end %>
```

## Class Attributes

**Always** use list `[...]` syntax for class attributes:

```heex
<a class={[
  "px-2 text-white",
  @some_flag && "py-5",
  if(@other_condition, do: "border-red-500", else: "border-blue-100")
]}>Text</a>
```

**Always** wrap `if` expressions in parentheses inside `{...}`.

**Never do this (invalid syntax):**
```heex
<a class={
  "px-2 text-white",
  @some_flag && "py-5"
}>
```

## Interpolation

- Use `{...}` for interpolation within tag attributes and simple values in tag bodies
- Use `<%= ... %>` for block constructs (`if`, `cond`, `case`, `for`) in tag bodies

**Correct:**
```heex
<div id={@id}>
  {@my_assign}
  <%= if @condition do %>
    {@value}
  <% end %>
</div>
```

**Invalid (never do this):**
```heex
<div id="<%= @invalid %>">
  {if @condition do}
  {end}
</div>
```

## Iterating Collections

**Always** use `for` comprehensions:
```heex
<%= for item <- @collection do %>
  <div>{item.name}</div>
<% end %>
```

**Never** use `<% Enum.each %>` for template content.

## Literal Curly Braces

Use `phx-no-curly-interpolation` for literal `{` or `}` in code snippets:

```heex
<code phx-no-curly-interpolation>
  let obj = {key: "val"}
</code>
```

Within annotated tags, use `<%= ... %>` for dynamic expressions.

## App-Wide Imports

Add shared imports to `my_app_web.ex`'s `html_helpers` block for availability in all LiveViews and components.
