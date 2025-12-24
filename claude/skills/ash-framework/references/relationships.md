# Relationships

## Contents
- [Relationship Types](#relationship-types)
- [Loading Relationships](#loading-relationships)
- [Managing Relationships](#managing-relationships)
- [Management Types](#management-types)

## Relationship Types

```elixir
relationships do
  # belongs_to - adds foreign key to source resource
  belongs_to :owner, MyApp.User do
    allow_nil? false
    attribute_type :integer  # defaults to :uuid
  end

  # has_one - foreign key on destination
  has_one :profile, MyApp.Profile

  # has_many - foreign key on destination, returns list
  has_many :posts, MyApp.Post do
    filter expr(published == true)
    sort published_at: :desc
  end

  # many_to_many - requires join resource
  many_to_many :tags, MyApp.Tag do
    through MyApp.PostTag
    source_attribute_on_join_resource :post_id
    destination_attribute_on_join_resource :tag_id
  end
end
```

### Join Resource

```elixir
defmodule MyApp.PostTag do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :added_at, :utc_datetime_usec, default: &DateTime.utc_now/0
  end

  relationships do
    belongs_to :post, MyApp.Post, primary_key?: true, allow_nil?: false
    belongs_to :tag, MyApp.Tag, primary_key?: true, allow_nil?: false
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end
end
```

**Best practices:**
- Use descriptive names (`:authored_posts` not `:posts`)
- Configure foreign key constraints in data layer
- For polymorphic relationships, use `Ash.Type.Union`

## Loading Relationships

```elixir
# Code interface (preferred)
post = MyDomain.get_post!(id, load: [:author, comments: [:author]])

# Complex loading with filters
posts = MyDomain.list_posts!(
  query: [load: [comments: [filter: [is_approved: true], limit: 5]]]
)

# Manual query building
MyApp.Post
|> Ash.Query.load(comments: MyApp.Comment |> Ash.Query.filter(is_approved == true))
|> Ash.read!()

# Loading on existing records
Ash.load!(post, :author)

# Strict loading - only specified fields
MyApp.Post
|> Ash.Query.load([comments: [:title]], strict?: true)
```

## Managing Relationships

### In Actions (from arguments)

```elixir
actions do
  update :update do
    argument :comments, {:array, :map}
    argument :new_tags, {:array, :map}

    change manage_relationship(:comments, type: :append)
    change manage_relationship(:new_tags, :tags, type: :append)
  end
end
```

### In Custom Changes (programmatic)

```elixir
defmodule MyApp.Changes.AssignTeamMembers do
  use Ash.Resource.Change

  def change(changeset, _opts, context) do
    members = determine_team_members(changeset, context.actor)

    Ash.Changeset.manage_relationship(
      changeset,
      :members,
      members,
      type: :append_and_remove
    )
  end
end
```

### Usage Examples

```elixir
# Create with new tags
MyDomain.create_post!(%{
  title: "New Post",
  tags: [%{name: "elixir"}, %{name: "ash"}]
})

# Update with existing tags by ID
MyDomain.update_post!(post, %{
  tags: [tag1.id, tag2.id]
})
```

## Management Types

| Type | Behavior |
|------|----------|
| `:append` | Add new, ignore existing |
| `:append_and_remove` | Add new, remove missing |
| `:remove` | Remove specified |
| `:direct_control` | Full CRUD |
| `:create` | Only create new |

### Common Options

- `on_lookup: :relate` - Look up and relate existing
- `on_no_match: :create` - Create if no match
- `on_match: :update` - Update existing matches
- `on_missing: :destroy` - Delete records not in input
- `value_is_key: :name` - Use field as key for simple values
