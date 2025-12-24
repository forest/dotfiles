---
name: phoenix-ecto
description: Critical Ecto and Phoenix guidelines that prevent common bugs and security issues. Use when writing Elixir code that involves Ecto schemas, changesets, queries, associations, or seeds.exs files. Prevents subtle mistakes with field access, validation options, and mass assignment vulnerabilities.
---

# Phoenix Ecto Guidelines

## Associations

Always preload associations in queries when they'll be accessed in templates or downstream code:

```elixir
# Good - preload when you need message.user.email
Repo.all(from m in Message, preload: [:user])

# Bad - will raise or N+1 query
messages = Repo.all(Message)
messages |> Enum.map(& &1.user.email)  # Ecto.Association.NotLoaded
```

## Schema Fields

Ecto.Schema fields always use `:string` type, even for database `:text` columns:

```elixir
# Correct
field :description, :string  # Even if DB column is TEXT

# Wrong - :text is not a valid Ecto type
field :description, :text
```

## Changeset Field Access

Use `Ecto.Changeset.get_field/2` to access changeset fields—never pattern match or access directly:

```elixir
# Good
Ecto.Changeset.get_field(changeset, :email)

# Bad - doesn't account for changes vs data
changeset.changes.email
changeset.data.email
```

## Validation Gotcha

`Ecto.Changeset.validate_number/2` does **not** support the `:allow_nil` option. By default, Ecto validations only run when:
1. A change for the field exists
2. The change value is not nil

So `:allow_nil` is never needed.

## Security: Mass Assignment

Fields set programmatically (like `user_id`) must **never** be listed in `cast` calls. Set them explicitly:

```elixir
# Good - user_id set explicitly, not in cast
def create_changeset(post, attrs, user) do
  post
  |> cast(attrs, [:title, :body])
  |> put_change(:user_id, user.id)
end

# Bad - allows user to set user_id via attrs
def create_changeset(post, attrs) do
  post
  |> cast(attrs, [:title, :body, :user_id])
end
```

## Seeds Files

Always import supporting modules in `seeds.exs`:

```elixir
import Ecto.Query
alias MyApp.Repo
alias MyApp.Accounts.User
```
