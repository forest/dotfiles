# The Core Challenge: Fragile Tests at Multiple Levels

**The Problem:** Both acceptance tests (story-level) and unit tests (sub-task level) can be fragile when not written well. Even small system changes often cause test breakages. We need durable tests that separate WHAT the system should do from HOW it does it at both levels.

**The Solution:** Apply the four-layer architecture at both levels - acceptance tests for complete user stories and unit tests for individual sub-tasks that separates WHAT the system should do from HOW it does it.

**For Elixir/Phoenix/Ash:** This architecture works beautifully with ExUnit, Phoenix.LiveViewTest, and Ash resources. The declarative nature of Ash and the functional approach of Elixir make the separation of concerns even clearer. **Critically, Ash policies (authorization rules) must be tested at both levels** - unit tests for individual policy logic, acceptance tests for policy effects on user workflows.

# Test Types and Their Purpose

## Acceptance Tests (User Story Level)

**Definition (Brian Marick's Model):** Tests that are **business-facing** and **support programming**

**Key Characteristics:**

- Test **complete user stories** end-to-end
- Written from perspective of **external user** of the system
- Focus on **WHAT** the system does for users
- Evaluate system in **life-like scenarios**
- Executed in **production-like test environments**
- When written before code, they become executable specifications that drive development

## Unit Tests (Sub-Task Level)

**Definition:** Tests that verify **individual sub-task functionality** in isolation

**Key Characteristics:**

- Test **single sub-task increments**
- Written from perspective of **developer using the component**
- Focus on **WHAT** the component does, not **HOW** it works internally
- Can be executed quickly and independently
- Drive development of individual commits through ATDD

# The Four-Layer Architecture (Applied at Both Levels)

## Layer 1: Test Cases (Executable Specifications)

**Purpose:** Express user scenarios in problem domain language only

**Example:**

```elixir
test "user can create and publish a recipe" do
  import MyApp.Generator

  # Given - Use generator to create authenticated user
  user = given_authenticated_user(role: :user)

  # When
  navigate_to_new_recipe_page(user)
  enter_recipe_details("Chocolate Cake", ingredients: ["flour", "sugar"])
  add_cooking_instructions("Mix and bake at 350°F")
  publish_recipe()

  # Then
  assert recipe_is_published()
  assert recipe_appears_in_user_feed()
end
```

**Key Properties:**

- Says **nothing** about how the system works (LiveView, API, forms, etc.)
- Uses same language as user story outline
- Could apply to **any** recipe app (web, mobile, API, etc.)
- Focuses purely on **user behavior and outcomes**

## Layer 2: DSL (Domain Specific Language)

**Purpose:** Make it easy to encode and capture test cases with good reuse

**Responsibilities:**

- Provides collection of **shared behaviors** across test cases
- Handles **optional parameters** and **default values**
- Creates **aliases** for system names (enables repeatable test runs)
- Parses inputs and manages test data
- **Optimized for writing test cases quickly and efficiently**

**Example:**

```elixir
def enter_recipe_details(name, opts \\ []) do
  # Handle optional parameters with defaults
  ingredients = Keyword.get(opts, :ingredients, [])
  servings = Keyword.get(opts, :servings, 4)

  # Call down to protocol driver layer
  protocol_driver().fill_recipe_form(name, ingredients, servings)
end
```

## Layer 3: Protocol Driver

**Purpose:** Translate problem domain language into real system interactions

**Key Insight:** Interface to protocol driver is **still high-level and abstract** (still uses problem domain language like "fill_recipe_form")

**Responsibilities:**

- **Only layer** that knows how the system actually works
- Translates abstract concepts into concrete system interactions:
  - **LiveView testing:** Uses `Phoenix.LiveViewTest` to find elements, trigger events
  - **API testing:** Makes HTTP calls to JSON:API endpoints
  - **Direct Ash calls:** Invokes Ash actions through code interface
  - **Whatever the natural interface** of your system is

**Example:**

```elixir
def fill_recipe_form(view, name, ingredients, servings) do
  # This layer knows about LiveView elements, form handling, etc.
  view
  |> form("#recipe-form", recipe: %{name: name, servings: servings})
  |> render_change()

  # Add ingredients one by one
  Enum.each(ingredients, fn ingredient ->
    view
    |> element("button[phx-click='add-ingredient']")
    |> render_click()

    view
    |> form("#ingredient-form", ingredient: %{name: ingredient})
    |> render_submit()
  end)
end
```

## Layer 4: System Under Test

**Purpose:** The actual system deployed in production-like test environment

# The Power of Separation of Concerns

## Test Reusability

**Same test case can work with different implementations:**

- Phoenix LiveView (via Phoenix.LiveViewTest)
- JSON:API (via HTTP calls with Req)
- GraphQL API (via Absinthe)
- Direct Ash actions (via code interface)
- Mobile app (via API calls)

**Only the protocol driver changes - test cases remain identical.**

## Maintenance Benefits

- **Test cases don't break** when UI changes
- **Only protocol driver needs updates** when system interface changes
- **Shared DSL** means fixing one function fixes multiple tests
- **Test cases remain correct** even when system is broken

## Development Benefits

- **Executable specifications** drive development from outside-in
- **Clear separation** between business requirements and technical implementation
- **Faster test writing** through DSL reuse
- **Better communication** with non-technical stakeholders

# Implementation Approaches

### Internal DSL (Preferred for Elixir)

- Hosted in Elixir using modules and functions
- Get all the tools of Elixir (pattern matching, pipe operator, etc.)
- Works seamlessly with ExUnit
- Examples shown use Elixir internal DSL

## External DSL

- Could use tools like Cabbage (Gherkin for Elixir)
- Same four-layer principles apply
- Feature steps become the DSL layer
- Step definitions become the protocol driver layer
- **Note:** Internal DSL is generally preferred in Elixir community

# Key Design Principles

## Test Case Layer Rules:

- **No technical details** - no mention of buttons, forms, LiveView events
- **Problem domain language only** - "publish recipe," not "click submit button"
- **System agnostic** - should work for any implementation
- **User behavior focused** - what user wants to achieve

## DSL Layer Rules:

- **Optimized for test writing** - make common cases easy
- **Handle complexity** - optional parameters, defaults, aliases
- **Promote reuse** - shared behaviors across tests
- **Still abstract** - no system-specific details
- **Use Elixir idioms** - keyword lists for options, pipe operator where helpful

## Protocol Driver Rules:

- **Only layer that knows system details** - LiveView elements, API endpoints, Ash actions
- **Translates abstractions** - from "publish recipe" to actual system calls
- **Handles system interface** - whatever the natural interface is
- **Isolates system coupling** - contains all fragile system dependencies

# Example: Recipe Creation Test Case

**User Story:** "I want to create and publish a recipe so others can discover it"

**Test Steps in Problem Domain Language:**

1. Log in as authenticated user
2. Navigate to new recipe page
3. Enter recipe details (name, ingredients, instructions)
4. Publish the recipe
5. Assert recipe appears in feed
6. Assert recipe is searchable by others

**Key Insight:** This description works for web app, mobile app, API, or any future implementation. Only the protocol driver changes.

# Wiring Acceptance and Unit Tests

## File Organization Structure

### **For Acceptance Tests (User Story Level):**

- **Layer 1:** `test/acceptance/[story]_test.exs` - User story executable specifications
- **Layer 2:** `test/acceptance/story_dsl.ex` - Story-level domain language
- **Layer 3:** `test/acceptance/[system]_driver.ex` - System-level protocol driver
- **Layer 4:** Complete integrated system

### **For Unit Tests (Sub-Task Level):**

- **Layer 1:** `test/[domain]/[resource]_test.exs` - Sub-task executable specifications
- **Layer 2:** `test/support/test_dsl.ex` - Component-level domain language
- **Layer 3:** `test/support/[module]_driver.ex` - Component protocol driver
- **Layer 4:** Individual Ash resource or module (e.g., `lib/my_app/recipes/recipe.ex`)

## Example: Recipe Publishing Story vs Sub-Task

### **Acceptance Test (Story Level)**

Tests the complete user story: "User can create and publish recipes"

**File:** `test/acceptance/recipe_publishing_test.exs`

```elixir
defmodule MyApp.Acceptance.RecipePublishingTest do
  use MyAppWeb.AcceptanceCase

  import MyApp.StoryDsl
  import MyApp.Generator

  test "user can create and publish a recipe" do
    # Given - Use generator to create authenticated user
    user = given_authenticated_user(role: :user)

    # When
    navigate_to_new_recipe_page(user)
    recipe = create_recipe_with_details(
      name: "Sourdough Bread",
      ingredients: ["flour", "water", "salt", "starter"]
    )
    publish_recipe(recipe)

    # Then
    assert recipe_is_published(recipe)
    assert recipe_appears_in_public_feed(recipe)
  end
end
```

### **Unit Test (Sub-Task Level)**

Tests individual sub-task: "Publishing a recipe triggers notifications"

**File:** `test/my_app/recipes/recipe_test.exs`

```elixir
defmodule MyApp.Recipes.RecipeTest do
  use MyApp.DataCase

  import MyApp.TestDsl
  import MyApp.Generator

  test "publishing a recipe creates notification for followers" do
    # Given - Use generators to create test data
    %{user: author, followers: _followers} = create_user_with_followers(follower_count: 3)
    recipe = create_unpublished_recipe(author: author, ingredient_count: 2)

    # When
    {:ok, published_recipe} = publish_recipe(recipe)

    # Then
    assert_notification_sent_to_followers(published_recipe, author)
    assert published_recipe.status == :published
  end
end
```

# Layer Implementation Examples

## Layer 2: Domain Specific Language (Different Levels)

### **Story-Level DSL** (`test/acceptance/story_dsl.ex`)

```elixir
defmodule MyApp.StoryDsl do
  alias MyApp.SystemDriver
  import MyApp.Generator

  @doc """
  Set up complete user with authentication via generator
  """
  def given_authenticated_user(opts \\ []) do
    # Use the generator to create a real user
    user = generate(user(opts))
    SystemDriver.login_user(user)
    user
  end

  @doc """
  End-to-end recipe creation through UI
  """
  def create_recipe_with_details(opts) do
    name = Keyword.fetch!(opts, :name)
    ingredients = Keyword.get(opts, :ingredients, [])

    SystemDriver.fill_recipe_form(name, ingredients)
    SystemDriver.submit_recipe_form()
  end

  @doc """
  Publish recipe through the UI
  """
  def publish_recipe(recipe) do
    SystemDriver.navigate_to_recipe(recipe)
    SystemDriver.click_publish_button()
  end

  @doc """
  Verify recipe appears as published
  """
  def recipe_is_published(recipe) do
    SystemDriver.recipe_has_status(recipe, :published)
  end
end
```

### **Component-Level DSL** (`test/support/test_dsl.ex`)

```elixir
defmodule MyApp.TestDsl do
  import MyApp.Generator

  @doc """
  Create test user with specified number of followers using generators
  """
  def create_user_with_followers(opts \\ []) do
    follower_count = Keyword.get(opts, :follower_count, 0)

    # Generate the main user
    user = generate(user(role: :user))

    # Generate followers and create follow relationships
    followers = generate_many(user(role: :user), follower_count)

    for follower <- followers do
      MyApp.Accounts.follow_user!(follower, user, authorize?: false)
    end

    %{user: user, followers: followers}
  end

  @doc """
  Create recipe in draft state using generator
  """
  def create_unpublished_recipe(opts) do
    author = Keyword.fetch!(opts, :author)

    # Use generator with seed? to create actual record
    generate(recipe(
      seed?: true,
      actor: author,
      status: :draft,
      ingredient_count: Keyword.get(opts, :ingredient_count, 0),
      instruction_count: Keyword.get(opts, :instruction_count, 0)
    ))
  end

  @doc """
  Publish recipe via Ash action
  """
  def publish_recipe(recipe) do
    MyApp.Recipes.publish_recipe(recipe)
  end

  @doc """
  Verify notifications were created
  """
  def assert_notification_sent_to_followers(recipe, author) do
    notifications = MyApp.Notifications.list_notifications_for_recipe(recipe.id)

    follower_ids =
      MyApp.Accounts.get_followers(author.id)
      |> Enum.map(& &1.id)
      |> MapSet.new()

    notification_recipient_ids =
      notifications
      |> Enum.map(& &1.recipient_id)
      |> MapSet.new()

    MapSet.equal?(follower_ids, notification_recipient_ids)
  end
end
```

## Layer 3: Protocol Driver (Different Scopes)

### **System Driver** (`test/acceptance/system_driver.ex`)

```elixir
defmodule MyApp.SystemDriver do
  @moduledoc """
  Drives the complete integrated system through LiveView
  """

  use Phoenix.ConnTest
  import Phoenix.LiveViewTest

  @endpoint MyAppWeb.Endpoint

  @doc """
  Set up complete environment including auth session
  """
  def create_and_login_user(opts) do
    user = create_user(opts)

    conn = build_conn()
    conn = log_in_user(conn, user)

    {:ok, _view, _html} = live(conn, "/")

    user
  end

  @doc """
  Test complete form interaction through LiveView
  """
  def fill_recipe_form(name, ingredients) do
    {:ok, view, _html} = live(conn, "/recipes/new")

    view
    |> form("#recipe-form", recipe: %{name: name})
    |> render_change()

    # Add each ingredient
    for ingredient <- ingredients do
      view
      |> element("button", "Add Ingredient")
      |> render_click()

      view
      |> form("#ingredient-form-#{length(ingredients)}",
              ingredient: %{name: ingredient})
      |> render_submit()
    end

    view
  end

  def submit_recipe_form(view) do
    view
    |> form("#recipe-form")
    |> render_submit()
  end
end
```

### **Component Driver** (`test/support/recipe_driver.ex`)

```elixir
defmodule MyApp.RecipeDriver do
  @moduledoc """
  Drives individual Ash resource actions directly
  """

  import MyApp.Generator

  @doc """
  Create recipe with specified number of ingredients using generator
  """
  def create_recipe_with_ingredients(author, ingredient_count) do
    generate(recipe(
      seed?: true,
      actor: author,
      ingredient_count: ingredient_count
    ))
  end

  @doc """
  Call the publish action on recipe resource
  """
  def call_publish_action(recipe) do
    MyApp.Recipes.publish_recipe(recipe)
  end

  @doc """
  Create favorite relationship using generator
  """
  def create_favorite(user, recipe) do
    generate(favorite(
      seed?: true,
      user_id: user.id,
      recipe_id: recipe.id
    ))
  end
end
```

# When to Use Each Level

## Acceptance Tests (Story Level)

- **Purpose**: Verify complete user stories work end-to-end
- **Scope**: Full system integration (LiveView + Ash + Database)
- **Frequency**: Run before story completion
- **Focus**: User outcomes and business value
- **Example**: "User can browse, create, and share recipes"

## Unit Tests (Sub-Task Level)

- **Purpose**: Verify individual sub-task functionality
- **Scope**: Single Ash resource action or module
- **Frequency**: Run with each commit (ATDD workflow)
- **Focus**: Component behavior and developer interface
- **Example**: "Publishing recipe sends notifications to followers"

# ATDD Workflow Integration

## Story Level (Acceptance Tests):

1. **Write story acceptance test** - defines complete user story behavior
2. **Break into sub-tasks** - each sub-task contributes to story completion
3. **Story test fails** (RED) - because sub-tasks aren't implemented yet
4. **Complete sub-tasks** using unit-level ATDD
5. **Story test passes** (GREEN) - when all sub-tasks are complete

## Sub-Task Level (Unit Tests):

1. **Write unit test** for sub-task behavior
2. **Test fails** (RED) - because Ash action/component doesn't exist yet
3. **Write minimal implementation** to pass test
4. **Test passes** (GREEN) - sub-task is complete
5. **Commit to trunk** - one working increment delivered

# Phoenix/Ash Specific Patterns

## Using Ash.Generator for Test Data

Ash provides a powerful generator system for creating test data that respects your resource definitions, validations, and policies.

### Basic Generator Patterns

**Layer 2 (DSL):** Wrap generators with domain language

```elixir
@doc """
Create a complete recipe with ingredients
"""
def given_recipe_with_ingredients(opts \\ []) do
  import MyApp.Generator

  generate(recipe(
    seed?: true,
    ingredient_count: Keyword.get(opts, :ingredient_count, 3),
    instruction_count: Keyword.get(opts, :instruction_count, 5)
  ))
end
```

**Layer 3 (Protocol Driver):** Use generators directly

```elixir
def setup_test_data do
  import MyApp.Generator

  # Create a user via generator
  user = generate(user(role: :user))

  # Create multiple recipes for that user
  recipes = generate_many(recipe(seed?: true, actor: user), 5)

  %{user: user, recipes: recipes}
end
```

### Generator Options

Key patterns from `MyApp.Generator`:

- **`seed?: true`** - Creates actual records in the database (not just changesets)
- **`actor:`** - Specify the actor for authorization
- **`actor_role:`** - Generate an actor with specific role
- **`generate()`** - Create a single record/changeset
- **`generate_many(generator, count)`** - Create multiple records
- **`once(:key, fn -> ... end)`** - Ensure something is generated only once per test

### Example: Complex Test Setup

```elixir
test "user can view all their saved recipes" do
  import MyApp.Generator

  # Generate user with specific role
  user = generate(user(role: :user))

  # Generate recipes created by other users
  other_recipes = generate_many(recipe(seed?: true, ingredient_count: 3), 5)

  # Create save relationships
  for recipe <- other_recipes do
    generate(save(seed?: true, user_id: user.id, recipe_id: recipe.id))
  end

  # Now test the behavior
  navigate_to_saved_recipes(user)
  assert saved_recipes_count_is(5)
end
```

### Generators vs Direct Creation

**Use generators when:**

- Creating realistic test data that respects validations
- Need to create related records (recipes with ingredients)
- Want test data that matches production patterns
- Creating multiple variations of similar data

**Use direct Ash actions when:**

- Testing specific edge cases with invalid data
- Need precise control over exact values
- Testing error handling and validation failures

```elixir
# Good: Use generator for realistic happy path data
recipe = generate(recipe(seed?: true, ingredient_count: 5))

# Good: Use direct action for testing validation
{:error, changeset} = MyApp.Recipes.create_recipe(%{name: ""})
assert changeset.errors[:name] == {"is required", []}
```

## Testing LiveView Interactions

**Layer 1 (Test Case):**

```elixir
test "user can filter recipes by ingredient" do
  import MyApp.Generator

  # Generate sample recipes with known ingredients
  user = generate(user(role: :user))
  chocolate_recipes = generate_many(recipe(seed?: true, actor: user), 3)
  vanilla_recipes = generate_many(recipe(seed?: true, actor: user), 2)

  navigate_to_recipes_page()
  filter_by_ingredient("chocolate")

  assert only_chocolate_recipes_shown(chocolate_recipes)
  refute any_vanilla_recipes_shown(vanilla_recipes)
end
```

**Layer 3 (Protocol Driver):**

```elixir
def filter_by_ingredient(view, ingredient) do
  view
  |> element("#ingredient-filter")
  |> render_change(%{filter: %{ingredient: ingredient}})
end
```

## Testing Ash Actions

**Layer 1 (Test Case):**

```elixir
test "favoriting recipe increases author reputation" do
  import MyApp.Generator

  # Generate author with multiple recipes
  author = generate(user(role: :user))
  recipes = generate_many(recipe(seed?: true, actor: author, ingredient_count: 3), 3)
  recipe = List.first(recipes)

  # Generate users who will favorite the recipe
  fans = generate_many(user(role: :user), 5)

  # When - fans favorite the recipe
  for fan <- fans do
    favorite_recipe(fan, recipe)
  end

  # Then
  assert author_reputation_increased(author)
end
```

**Layer 3 (Protocol Driver):**

```elixir
def favorite_recipe(user, recipe) do
  import MyApp.Generator

  generate(favorite(
    seed?: true,
    user_id: user.id,
    recipe_id: recipe.id
  ))
end

def author_reputation_increased(author) do
  updated_author = MyApp.Accounts.get_user!(author.id)
  updated_author.reputation > author.reputation
end
```

## Testing Ash Policies - CRITICAL for Ash Applications

**Policies are core business logic in Ash.** Authorization is not an afterthought - it's declaratively defined in your resources and must be thoroughly tested at both levels.

### Unit-Level Policy Tests (Sub-Task Level)

Test individual authorization rules directly using Ash's auto-generated `can_*?` functions:

```elixir
describe "recipe authorization policies" do
  setup do
    %{
      admin: generate(user(role: :admin)),
      user: generate(user(role: :user)),
      other_user: generate(user(role: :user))
    }
  end

  test "users and admins can create recipes", %{admin: admin, user: user} do
    assert Recipes.can_create_recipe?(admin)
    assert Recipes.can_create_recipe?(user)
    refute Recipes.can_create_recipe?(nil)
  end

  test "users can only update their own recipes", %{user: user, other_user: other} do
    my_recipe = generate(recipe(seed?: true, created_by: user))
    other_recipe = generate(recipe(seed?: true, created_by: other))

    assert Recipes.can_update_recipe?(user, my_recipe)
    refute Recipes.can_update_recipe?(user, other_recipe)
  end

  test "admins can update any recipe", %{admin: admin, user: user} do
    recipe = generate(recipe(seed?: true, created_by: user))

    assert Recipes.can_update_recipe?(admin, recipe)
  end

  test "users can delete recipes they created", %{user: user, other_user: other} do
    my_recipe = generate(recipe(seed?: true, created_by: user))
    other_recipe = generate(recipe(seed?: true, created_by: other))

    assert Recipes.can_destroy_recipe?(user, my_recipe)
    refute Recipes.can_destroy_recipe?(user, other_recipe)
  end

  test "admins can delete any recipe", %{admin: admin} do
    recipe = generate(recipe(seed?: true))

    assert Recipes.can_destroy_recipe?(admin, recipe)
  end
end
```

### Acceptance-Level Policy Tests (Story Level)

Test that policies correctly affect user workflows in the UI:

**Layer 1 (Test Case):**

```elixir
test "user cannot delete another user's recipe through UI" do
  import MyApp.Generator

  # Given - two users with recipes
  author = given_authenticated_user(role: :user)
  other_user = generate(user(role: :user))

  author_recipe = generate(recipe(seed?: true, actor: author))
  other_recipe = generate(recipe(seed?: true, actor: other_user))

  # When - viewing recipes page
  navigate_to_recipes_page()

  # Then - user sees delete button only on their own recipe
  assert delete_button_visible_for_recipe(author_recipe)
  refute delete_button_visible_for_recipe(other_recipe)

  # And - attempting to delete other's recipe fails
  assert_cannot_delete_recipe(other_recipe)
end
```

**Layer 3 (Protocol Driver):**

```elixir
def assert_cannot_delete_recipe(recipe) do
  # Attempt deletion through UI
  view
  |> element("#recipe-#{recipe.id} [phx-click='delete']")
  |> render_click()

  # Verify error message shown
  assert has_element?(view, ".error", "You don't have permission")

  # Verify recipe still exists
  assert Recipes.get_recipe_by_id(recipe.id)
end
```

### Why Both Levels Matter

**Unit-Level Policy Tests:**
- Fast, isolated tests of authorization rules
- Test all edge cases and permission combinations
- Run on every commit
- Catch policy logic errors immediately
- **Use `can_*?` functions auto-generated by Ash**

**Acceptance-Level Policy Tests:**
- Verify policies integrate correctly with UI/API
- Test user experience of authorization failures
- Ensure proper error messages shown
- Catch UI bugs where unauthorized actions are exposed
- Test the complete authorization flow

### Key Patterns for Policy Testing

**Test both positive and negative cases:**

```elixir
test "recipe favoriting authorization" do
  user = generate(user(role: :user))
  recipe = generate(recipe(seed?: true))

  # Positive: authenticated users can favorite
  assert Recipes.can_favorite_recipe?(user, recipe)

  # Negative: unauthenticated cannot favorite
  refute Recipes.can_favorite_recipe?(nil, recipe)
end
```

**Test role-based permissions:**

```elixir
test "role-based recipe management" do
  admin = generate(user(role: :admin))
  user = generate(user(role: :user))
  recipe = generate(recipe(seed?: true))

  # Admins have full access
  assert Recipes.can_update_recipe?(admin, recipe)
  assert Recipes.can_destroy_recipe?(admin, recipe)

  # Regular users have limited access
  refute Recipes.can_update_recipe?(user, recipe)
  refute Recipes.can_destroy_recipe?(user, recipe)
end
```

**Test ownership-based permissions:**

```elixir
test "ownership determines edit permissions" do
  owner = generate(user(role: :user))
  other = generate(user(role: :user))
  recipe = generate(recipe(seed?: true, created_by: owner))

  # Owner can edit
  assert Recipes.can_update_recipe?(owner, recipe)

  # Others cannot
  refute Recipes.can_update_recipe?(other, recipe)
end
```

### Testing Policy Failures

Test that policy violations raise appropriate errors:

```elixir
test "unauthorized deletion raises Forbidden error" do
  user = generate(user(role: :user))
  other_recipe = generate(recipe(seed?: true))

  assert_raise Ash.Error.Forbidden, fn ->
    Recipes.destroy_recipe(other_recipe, actor: user)
  end
end
```

# Key Design Principles

## Acceptance Test Rules (Story Level):

- **Complete user workflows** - test entire user journeys through LiveView
- **Business outcomes** - verify user value is delivered
- **System integration** - test how Ash resources, LiveViews, and database work together
- **Production-like environment** - use test database with realistic data

## Unit Test Rules (Sub-Task Level):

- **Component isolation** - test individual Ash actions or modules
- **Developer interface** - test how developers use the code interface
- **Fast execution** - enable rapid feedback during development via `mix test`
- **Implementation independence** - survive internal changes to Ash resource definitions
- **CRITICAL: Test Ash policies** - use auto-generated `can_*?` functions to test all authorization rules

## Elixir/Phoenix Specific Guidelines:

- **Use pattern matching** in assertions: `assert %{status: :published} = recipe`
- **Leverage ExUnit features** - tags, describe blocks, setup callbacks
- **Use Phoenix.ConnTest** for controller tests (if needed)
- **Use Phoenix.LiveViewTest** for LiveView acceptance tests
- **Test through Ash code interface** - not internal Ash.Query calls
- **Use ExUnit.CaptureLog** for testing logging side effects
- **Tag slow tests** with `@tag :acceptance` to run selectively

## Best Practices for Ash.Generator in Test Layers:

### Layer 1 (Test Case Layer)

```elixir
# Import generator at test level
test "user can save favorite recipes" do
  import MyApp.Generator

  user = given_authenticated_user()
  recipe = given_published_recipe()

  # Rest of test...
end
```

### Layer 2 (DSL Layer)

```elixir
# DSL wraps generators with domain language
def given_authenticated_user(opts \\ []) do
  import MyApp.Generator
  user = generate(user(opts))
  # Additional setup like authentication
  user
end

def given_published_recipe(opts \\ []) do
  import MyApp.Generator
  generate(recipe(Keyword.merge([seed?: true, status: :published], opts)))
end
```

### Layer 3 (Protocol Driver Layer)

```elixir
# Protocol driver uses generators directly for creating test data
def setup_recipe_with_favorites(recipe, favorite_count) do
  import MyApp.Generator

  users = generate_many(user(role: :user), favorite_count)

  for user <- users do
    generate(favorite(seed?: true, user_id: user.id, recipe_id: recipe.id))
  end
end
```

### Key Generator Patterns

**Always use `seed?: true` when you need actual records:**

```elixir
# Creates record in database
recipe = generate(recipe(seed?: true))

# Creates changeset only (for testing validations)
changeset = generate(recipe())
```

**Use `once/2` for shared test data:**

```elixir
# In your generator module
def recipe(opts \\ []) do
  actor = opts[:actor] || once(:default_actor, fn ->
    generate(user(role: :user))
  end)
  # ...
end
```

**Leverage generator options for test variations:**

```elixir
# Simple recipe
recipe = generate(recipe(seed?: true))

# Recipe with relationships
recipe = generate(recipe(
  seed?: true,
  ingredient_count: 5,
  instruction_count: 10,
  actor: specific_user
))
```

---

**Core Takeaway:** Apply the four-layer architecture at both story level (acceptance tests with LiveView) and sub-task level (unit tests with Ash actions). This creates a comprehensive testing strategy where acceptance tests verify complete user value while unit tests enable rapid development of individual components through ATDD. The declarative nature of Ash and the functional approach of Elixir make this separation natural and maintainable.

**CRITICAL for Ash Applications:** Policies are core business logic - always test authorization at both levels:
- **Unit level:** Test individual policies with `can_*?` functions
- **Acceptance level:** Test policy effects on user workflows
- **Complete coverage:** Test positive cases (allowed), negative cases (forbidden), role-based, and ownership-based permissions
