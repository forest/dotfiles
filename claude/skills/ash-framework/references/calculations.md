# Calculations & Aggregates

## Contents
- [Expression Calculations](#expression-calculations)
- [Module Calculations](#module-calculations)
- [Calculations with Arguments](#calculations-with-arguments)
- [Using Calculations](#using-calculations)
- [Aggregates](#aggregates)
- [Exists Expressions](#exists-expressions)
- [Expressions Outside Resources](#expressions-outside-resources)

## Expression Calculations

```elixir
calculations do
  calculate :full_name, :string, expr(first_name <> " " <> last_name)

  calculate :status_label, :string, expr(
    cond do
      status == :active -> "Active"
      status == :pending -> "Pending Review"
      true -> "Inactive"
    end
  )

  calculate :total_with_tax, :decimal, expr(amount * (1 + tax_rate))

  calculate :days_since_created, :integer, expr(
    date_diff(^now(), inserted_at, :day)
  )
end
```

## Module Calculations

```elixir
defmodule MyApp.Calculations.FullName do
  use Ash.Resource.Calculation

  @impl true
  def init(opts), do: {:ok, Map.put_new(opts, :separator, " ")}

  @impl true
  def load(_query, _opts, _context), do: [:first_name, :last_name]

  @impl true
  def calculate(records, opts, _context) do
    Enum.map(records, fn record ->
      [record.first_name, record.last_name]
      |> Enum.reject(&is_nil/1)
      |> Enum.join(opts.separator)
    end)
  end
end

# Usage
calculate :full_name, :string, {MyApp.Calculations.FullName, separator: ", "}
```

## Calculations with Arguments

```elixir
calculations do
  calculate :full_name, :string, expr(first_name <> ^arg(:separator) <> last_name) do
    argument :separator, :string do
      allow_nil? false
      default " "
      constraints [allow_empty?: true, trim?: false]
    end
  end
end
```

## Using Calculations

```elixir
# Code interface (preferred)
users = MyDomain.list_users!(load: [full_name: [separator: ", "]])

# Filtering and sorting
users = MyDomain.list_users!(
  query: [
    filter: [full_name: [separator: " ", value: "John Doe"]],
    sort: [full_name: {[separator: " "], :asc}]
  ]
)

# Code interface for standalone use
resource User do
  define_calculation :full_name, args: [:first_name, :last_name, {:optional, :separator}]
end

MyDomain.full_name("John", "Doe", ", ")  # Returns "John, Doe"
```

## Aggregates

```elixir
aggregates do
  # Related aggregates
  count :published_post_count, :posts do
    filter expr(published == true)
  end

  sum :total_sales, :orders, :amount

  exists :is_admin, :roles do
    filter expr(name == "admin")
  end

  # Unrelated aggregates - use resource module, parent() for source fields
  count :matching_profiles_count, Profile do
    filter expr(name == parent(name))
  end

  exists :has_reports, Report do
    filter expr(author_name == parent(name))
  end
end
```

### Aggregate Types

- `count` - Count related items
- `sum` - Sum a field
- `exists` - Boolean for matching items
- `first` - First matching value
- `list` - List of field values
- `max` / `min` - Max/min value
- `avg` - Average value

### Join Filters

```elixir
sum :redeemed_deal_amount, [:redeems, :deal], :amount do
  filter expr(redeems.redeemed == true)
  join_filter :redeems, expr(redeemed == true)
  join_filter [:redeems, :deal], expr(active == parent(require_active))
end
```

### Inline Aggregates

```elixir
calculate :grade_percentage, :decimal, expr(
  count(answers, query: [filter: expr(correct == true)]) * 100 /
  count(answers)
)

calculate :stats, :map, expr(%{
  profiles: count(Profile, filter: expr(active == true)),
  reports: count(Report, filter: expr(author_name == parent(name))),
  has_active_profile: exists(Profile, active == true and name == parent(name))
})
```

## Exists Expressions

### Related Exists

```elixir
Ash.Query.filter(User, exists(roles, name == "admin"))
Ash.Query.filter(Post, exists(comments, score > 50))
```

### Unrelated Exists

```elixir
Ash.Query.filter(User, exists(Profile, name == parent(name)))
Ash.Query.filter(User, exists(Report, author_name == parent(name)))

Ash.Query.filter(User,
  active == true and
  exists(Profile, active == true and name == parent(name))
)
```

Use `parent/1` to reference source resource fields in unrelated exists.

## Expressions Outside Resources

Use `Ash.Expr` with `import` for expressions outside resources:

```elixir
import Ash.Expr

Author
|> Ash.Query.aggregate(:count_of_my_favorited_posts, :count, [:posts], query: [
  filter: expr(favorited_by(user_id: ^actor(:id)))
])
```

Provides `expr/1` and template helpers like `actor/1` and `arg/1`.
