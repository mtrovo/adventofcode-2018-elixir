defmodule Adventofcode2018 do
  defmacro __using__(options) do
    quote do
      import Adventofcode2018

      def puzzle_input do
        read_puzzle_input_for(__MODULE__, unquote(options))
      end
    end
  end

  defmodule Edge do
    defstruct [:src, :dst]
  end

  def edge(a, b) do
    %Edge{src: a, dst: b}
  end

  def cross_prod([], _) do
    []
  end

  def cross_prod([a | as], bs) do
    Stream.map(bs, &{a, &1})
    |> Stream.concat(cross_prod(as, bs))
  end

  def freq_map(list) do
    list
    |> Enum.group_by(& &1, fn _ -> 1 end)
    |> Map.to_list()
    |> Map.new(fn {k, vs} ->
      {k, length(vs)}
    end)
  end

  def bounding_box(cs, state \\ {9999, 9999, 0, 0})

  def bounding_box([], state) do
    state
  end

  def bounding_box([{cx, cy} | cs], {topx, topy, botx, boty}) do
    topx = if(cx < topx, do: cx, else: topx)
    botx = if(cx > botx, do: cx, else: botx)
    topy = if(cy < topy, do: cy, else: topy)
    boty = if(cy > boty, do: cy, else: boty)

    bounding_box(cs, {topx, topy, botx, boty})
  end

  @doc false
  def read_puzzle_input_for(module, options) do
    fname = Path.join(["input", input_filename(module) <> ".txt"])

    case File.read(fname) do
      {:ok, data} -> trim(data, Keyword.get(options, :trim))
      {:error, _} -> nil
    end
  end

  defp input_filename(module) do
    module
    |> to_string()
    |> String.split(".")
    |> Enum.at(2)
    |> Macro.underscore()
    |> String.replace(~r/(\w)(\d)/, "\\1_\\2", global: false)
  end

  defp trim(text, false), do: String.trim_trailing(text, "\n")
  defp trim(text, _), do: String.trim(text)
end
