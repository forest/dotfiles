# Authorization & Policies

## Contents
- [Setup](#setup)
- [Policy Basics](#policy-basics)
- [Policy Evaluation Flow](#policy-evaluation-flow)
- [AND vs OR Logic](#and-vs-or-logic)
- [Bypass Policies](#bypass-policies)
- [Field Policies](#field-policies)
- [Custom Checks](#custom-checks)

## Setup

```elixir
defmodule MyApp.Post do
  use Ash.Resource,
    domain: MyApp.Blog,
    authorizers: [Ash.Policy.Authorizer]
end
```

**Always set actor on query/changeset, not when calling action:**

```elixir
# GOOD
Post
|> Ash.Query.for_read(:read, %{}, actor: current_user)
|> Ash.read!()

# BAD - DO NOT DO THIS
Post
|> Ash.Query.for_read(:read, %{})
|> Ash.read!(actor: current_user)
```

Use `authorize?: false` for administrative actions.

## Policy Basics

```elixir
policies do
  policy action_type(:read) do
    authorize_if expr(public == true)
    authorize_if relates_to_actor_via(:owner)
  end

  policy action_type(:create) do
    forbid_unless actor_attribute_equals(:active, true)
    authorize_if relating_to_actor(:owner)
  end
end
```

## Policy Evaluation Flow

1. All policies that apply must pass
2. Within each policy, checks evaluate top to bottom
3. **First check that produces a decision determines the policy result**
4. If no check produces a decision, policy defaults to forbidden

## AND vs OR Logic

**CRITICAL**: The first check that yields a result determines outcome.

```elixir
# WRONG - This is OR logic!
policy action_type(:update) do
  authorize_if actor_attribute_equals(:admin?, true)  # If passes, policy passes
  authorize_if relates_to_actor_via(:owner)           # Only checked if first fails
end

# CORRECT - Require BOTH conditions
policy action_type(:update) do
  forbid_unless actor_attribute_equals(:admin?, true)  # Must be admin
  authorize_if relates_to_actor_via(:owner)            # AND must be owner
end
```

**AND patterns:**
- Multiple separate policies (each must pass independently)
- Single expression: `expr(condition1 and condition2)`
- `forbid_unless` for required conditions, then `authorize_if` for final check

## Bypass Policies

For admin access that skips other policies:

```elixir
policies do
  bypass actor_attribute_equals(:admin, true) do
    authorize_if always()
  end

  # Regular policies follow...
end
```

## Field Policies

Control access to specific fields:

```elixir
field_policies do
  field_policy :salary do
    authorize_if actor_attribute_equals(:role, :supervisor)
  end

  field_policy :* do
    authorize_if always()
  end
end
```

## Custom Checks

### Simple Check (true/false)

```elixir
defmodule MyApp.Checks.ActorHasRole do
  use Ash.Policy.SimpleCheck

  def match?(%{role: actor_role}, _context, opts) do
    actor_role == (opts[:role] || :admin)
  end
  def match?(_, _, _), do: false
end

# Usage
authorize_if {MyApp.Checks.ActorHasRole, role: :manager}
```

### Filter Check (returns query filter)

```elixir
defmodule MyApp.Checks.VisibleToUserLevel do
  use Ash.Policy.FilterCheck

  def filter(actor, _authorizer, _opts) do
    expr(visibility_level <= ^actor.user_level)
  end
end

# Usage
authorize_if MyApp.Checks.VisibleToUserLevel
```
