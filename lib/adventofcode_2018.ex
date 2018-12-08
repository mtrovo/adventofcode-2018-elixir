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
