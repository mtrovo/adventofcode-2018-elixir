defmodule Adventofcode2018.Day08MemoryManeuverP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day08MemoryManeuverP2

  describe "root_node_value/1" do
    test "sample input" do
      assert 66 = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2" |> root_node_value()
    end

    test_with_puzzle_input do
      assert 19276 = puzzle_input() |> root_node_value()
    end
  end
end
