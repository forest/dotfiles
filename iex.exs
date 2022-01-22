if :mix not in Enum.map(Application.loaded_applications(), &elem(&1, 0)) do
  Mix.install([
    :decimal,
    :req,
    # {:req, path: "~/code/req"},
  ])
end

defmodule MyInspect do
  def inspect(%URI{} = url, _opts) do
    "#URI[" <> URI.to_string(url) <> "]"
  end

  def inspect(%Date.Range{step: 1} = daterange, _opts) do
    "~Date.Range[#{daterange.first}/#{daterange.last}]"
  end

  def inspect(%Date.Range{} = daterange, _opts) do
    "~Date.Range[#{daterange.first}/#{daterange.last}//#{daterange.step}]"
  end

  def inspect(term, opts) do
    Inspect.inspect(term, opts)
  end
end

Inspect.Opts.default_inspect_fun(&MyInspect.inspect/2)

IEx.configure(
  colors: [
    syntax_colors: [
      number: :light_yellow,
      atom: :light_cyan,
      string: :yellow,
      boolean: :red,
      nil: [:magenta, :bright],
    ],
    eval_result: [ :cyan, :bright ],
  ],

  history_size: 50,

  inspect: [
    pretty: true,
    limit: :infinity,
    width: 80
  ],

  width: 80
)

# import Sigils
