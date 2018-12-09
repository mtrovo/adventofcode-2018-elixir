defmodule Adventofcode2018.Day08MemoryManeuverP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day08MemoryManeuverP1

  describe "parse_input/1" do
    test "return a list of integers" do
      assert [2, 3, 0, 3] = parse_input("2 3 0 3")
    end
  end

  describe "parse_nodes/2" do
    nodes = [
      node(2, [1, 1, 2]),
      node(1, [2]),
      node(0, [99]),
      node(0, [10, 11, 12])
    ]

    assert {[], ^nodes} =
             "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
             |> parse_input
             |> parse_nodes
  end

  describe "metadata_sum/1" do
    test "sample input" do
      assert 138 = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2" |> metadata_sum()
    end

    test_with_puzzle_input do
      assert 1337 = puzzle_input() |> metadata_sum()
    end
  end
end
