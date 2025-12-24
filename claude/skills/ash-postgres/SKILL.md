---
name: ash-postgres
description: AshPostgres data layer guidelines for PostgreSQL with Ash Framework. Use when configuring postgres blocks, foreign key references, check constraints, custom indexes, migrations, or multitenancy. The default choice for Ash data layers. Supports PostgreSQL 13+.
---

# AshPostgres Guidelines

AshPostgres is the most fully-featured Ash data layer and should be your default choice.

## Basic Configuration

```elixir
defmodule MyApp.Tweet do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key :id
    attribute :text, :string
  end

  relationships do
    belongs_to :author, MyApp.User
  end

  postgres do
    table "tweets"
    repo MyApp.Repo
  end
end
```

## Foreign Key References

```elixir
postgres do
  table "comments"
  repo MyApp.Repo

  references do
    reference :post  # Simple with defaults

    reference :user,
      on_delete: :delete,       # What happens when referenced row deleted
      on_update: :update,       # What happens when referenced row updated
      name: "comments_to_users_fkey",
      deferrable: true,
      initially_deferred: false
  end
end
```

### Foreign Key Actions

| Action | Behavior |
|--------|----------|
| `:nothing` / `:restrict` | Prevent the change |
| `:delete` | Delete row when referenced deleted (on_delete only) |
| `:update` | Update according to referenced changes (on_update only) |
| `:nilify` | Set all FK columns to NULL |
| `{:nilify, columns}` | Set specific columns to NULL (PG 15+) |

> **Warning**: FK actions happen at database level. No resource logic, authorization, validations, or notifications trigger.

## Check Constraints

```elixir
postgres do
  check_constraints do
    check_constraint :positive_amount,
      check: "amount > 0",
      name: "positive_amount_check",
      message: "Amount must be positive"

    check_constraint :status_valid,
      check: "status IN ('pending', 'active', 'completed')"
  end
end
```

## Custom Indexes

```elixir
postgres do
  custom_indexes do
    index [:first_name, :last_name]

    index :email,
      unique: true,
      name: "users_email_index",
      where: "email IS NOT NULL",
      using: :gin

    index [:status, :created_at],
      concurrently: true,
      include: [:user_id]
  end
end
```

## Custom SQL Statements

```elixir
postgres do
  custom_statements do
    statement "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""

    statement """
    CREATE TRIGGER update_updated_at
    BEFORE UPDATE ON posts
    FOR EACH ROW
    EXECUTE FUNCTION trigger_set_timestamp();
    """

    statement "DROP INDEX IF EXISTS posts_title_index",
      on_destroy: true  # Only run when resource destroyed
  end
end
```

## Migration Workflow

### Development (Recommended)

1. Make resource changes
2. Run `mix ash.codegen --dev` to generate/run dev migrations
3. Review and run `mix ash.migrate`
4. Continue iterating with `--dev`
5. When feature complete: `mix ash.codegen add_feature_name` (squashes dev migrations)
6. Review and run `mix ash.migrate`

### Traditional

```bash
mix ash.codegen add_feature_name
# Review migrations in priv/repo/migrations
mix ash.migrate
```

> **Tip**: The `--dev` workflow is preferred during development - iterate without naming migrations.

> **Warning**: Always review migrations before applying.

## Multitenancy

### Configure Tenant Resource

```elixir
defmodule MyApp.Tenant do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tenants"
    repo MyApp.Repo

    manage_tenant do
      template ["tenant_", :id]
    end
  end
end
```

### Configure Repo

```elixir
defmodule MyApp.Repo do
  use AshPostgres.Repo, otp_app: :my_app

  def all_tenants do
    import Ecto.Query, only: [from: 2]
    all(from(t in "tenants", select: fragment("? || ?", "tenant_", t.id)))
  end
end
```

### Mark Multi-tenant Resources

```elixir
defmodule MyApp.Post do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  multitenancy do
    strategy :context
    attribute :tenant
  end
end
```

### Run Migrations

```bash
mix ash.migrate              # Regular migrations
mix ash_postgres.migrate --tenants  # Tenant migrations (in priv/repo/tenant_migrations)
```

## Read Replicas

```elixir
postgres do
  repo fn _resource, type ->
    case type do
      :read -> MyApp.ReadReplicaRepo
      :mutate -> MyApp.WriteRepo
    end
  end
end
```

## Manual Relationships

For complex relationships:

```elixir
defmodule MyApp.Post.Relationships.HighlyRatedComments do
  use Ash.Resource.ManualRelationship
  use AshPostgres.ManualRelationship

  def load(posts, _opts, _context) do
    post_ids = Enum.map(posts, & &1.id)

    {:ok,
     MyApp.Comment
     |> Ash.Query.filter(post_id in ^post_ids)
     |> Ash.Query.filter(rating > 4)
     |> MyApp.read!()
     |> Enum.group_by(& &1.post_id)}
  end

  def ash_postgres_join(query, _opts, current_binding, as_binding, :inner, destination_query) do
    {:ok,
     Ecto.Query.from(_ in query,
       join: dest in ^destination_query,
       as: ^as_binding,
       on: dest.post_id == as(^current_binding).id,
       on: dest.rating > 4
     )}
  end
end

# In resource
relationships do
  has_many :highly_rated_comments, MyApp.Comment do
    manual MyApp.Post.Relationships.HighlyRatedComments
  end
end
```

## Best Practices

1. **Use check constraints for domain invariants** - Enforce at database level
2. **Use custom statements for schema-only changes** - Extensions, triggers, non-resource indexes
3. **Name migrations descriptively**: `mix ash.codegen add_user_roles`
