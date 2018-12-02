defmodule Adventofcode2018.AdventCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Adventofcode2018.AdventCase
    end
  end

  setup _tags do
    :ok
  end

  defmacro test_with_puzzle_input(options) do
    quote do
      test "with_puzzle_input" do
        if puzzle_input() do
          unquote(Keyword.get(options, :do))
        else
          raise("No puzzle found for day")
        end
      end
    end
  end
end
