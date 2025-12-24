# Prompt-Backed Actions Reference

## Contents
- [Prompt Format Options](#prompt-format-options)
- [Adapters](#adapters)
- [Best Practices](#best-practices)

## Prompt Format Options

### 1. String (EEx Template)

Simple templates with `@input` and `@context`:

```elixir
run prompt(
  ChatOpenAI.new!(%{model: "gpt-4o"}),
  prompt: "Analyze the sentiment of: <%= @input.arguments.text %>"
)
```

### 2. System/User Tuple

Separate system and user messages:

```elixir
run prompt(
  ChatOpenAI.new!(%{model: "gpt-4o"}),
  prompt: {"You are a sentiment analyzer", "Analyze: <%= @input.arguments.text %>"}
)
```

### 3. LangChain Messages List

For complex multi-turn conversations:

```elixir
run prompt(
  ChatOpenAI.new!(%{model: "gpt-4o"}),
  prompt: [
    Message.new_system!("You are an expert assistant"),
    Message.new_user!("Hello, how can you help me?"),
    Message.new_assistant!("I can help with various tasks"),
    Message.new_user!("Great! Please analyze this data")
  ]
)
```

For image analysis with templates:

```elixir
run prompt(
  ChatOpenAI.new!(%{model: "gpt-4o"}),
  prompt: [
    Message.new_system!("You are an expert at image analysis"),
    Message.new_user!([
      PromptTemplate.from_template!("Extra context: <%= @input.arguments.context %>"),
      ContentPart.image!("<%= @input.arguments.image_data %>", media: :jpg, detail: "low")
    ])
  ]
)
```

### 4. Dynamic Function

Return any format based on input:

```elixir
run prompt(
  ChatOpenAI.new!(%{model: "gpt-4o"}),
  prompt: fn input, context ->
    base = [Message.new_system!("You are helpful")]

    history = input.arguments.conversation_history
    |> Enum.map(fn %{"role" => role, "content" => content} ->
      case role do
        "user" -> Message.new_user!(content)
        "assistant" -> Message.new_assistant!(content)
      end
    end)

    base ++ history
  end
)
```

### Template Processing

- **String prompts**: Processed as EEx with `@input` and `@context`
- **Messages with PromptTemplate**: Uses LangChain's `apply_prompt_templates`
- **Functions**: Can return any supported format

If no prompt provided, default template includes action name, description, and arguments.

## Adapters

Adapters control how the LLM generates structured outputs.

### Default Selection

| LLM | Adapter |
|-----|---------|
| OpenAI API | `StructuredOutput` (native structured output) |
| Non-OpenAI | `RequestJson` (requests JSON in prompt) |
| Anthropic | `CompletionTool` (tool calling) |

### Custom Adapter

```elixir
# Use specific adapter
run prompt(
  ChatOpenAI.new!(%{model: "gpt-4o"}),
  adapter: AshAi.Actions.Prompt.Adapter.RequestJson,
  tools: false
)

# Adapter with options
run prompt(
  ChatOpenAI.new!(%{model: "gpt-4o"}),
  adapter: {AshAi.Actions.Prompt.Adapter.StructuredOutput, [some_option: :value]},
  tools: false
)
```

### Available Adapters

| Adapter | Best For |
|---------|----------|
| `StructuredOutput` | OpenAI models, native structured output |
| `RequestJson` | Any model, requests JSON in prompt |
| `CompletionTool` | Models with function calling |

## Best Practices

1. **Write clear descriptions** for action and arguments
2. **Use constraints** to restrict outputs (e.g., `one_of:`)
3. **Choose appropriate prompt format**:
   - String templates for simple prompts
   - System/user tuples for role-based interactions
   - Message lists for complex conversations or multi-modal
   - Functions for dynamic generation
4. **Test thoroughly** with different inputs
5. **Use dynamic LLM config** for runtime configuration:

```elixir
run prompt(
  fn _input, _context ->
    LangChain.ChatModels.ChatOpenAI.new!(%{
      model: "gpt-4o",
      api_key: System.get_env("OPENAI_API_KEY"),
      endpoint: System.get_env("OPENAI_ENDPOINT")
    })
  end,
  tools: false
)
```
