defmodule Adventofcode2018.Day07TheSumOfItsPartsP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018
  import Adventofcode2018.Day07TheSumOfItsPartsP1

  describe "parse_input" do
    test "return directed edge on success" do
      e = edge("C", "A")

      assert ^e =
               "Step C must be finished before step A can begin."
               |> parse_line
    end
  end

  describe "build_graph/3" do
    test "return direct graph and its inverse" do
      assert {%{
                a: [:b],
                b: [:c],
                d: [:b]
              },
              %{
                b: [:d, :a],
                c: [:b]
              }} =
               build_graph([
                 edge(:a, :b),
                 edge(:b, :c),
                 edge(:d, :b)
               ])
    end
  end

  describe "find_all_leaves/4" do
    test "return single leave of graph" do
      assert [:c] = find_all_leaves([:b, :c], %{a: [:b], b: [:c], d: [:b]})
    end

    test "return all leaves of graph" do
      assert [:d, :a] = find_all_leaves([:a, :b, :d], %{b: [:d, :a], c: [:b]})
    end
  end

  describe "remove_edges/4" do
    test "remove and return updated graph" do
      assert {%{
                "B" => ["A"],
                "D" => ["A"],
                "E" => ["F", "D", "B"]
              },
              ["A", "F"]} =
               remove_edges(
                 %{
                   "A" => ["C"],
                   "B" => ["A"],
                   "D" => ["A"],
                   "E" => ["F", "D", "B"],
                   "F" => ["C"]
                 },
                 ["F", "A"],
                 "C"
               )
    end
  end

  describe "steps_in_order/1" do
    test "sample input" do
      assert "CABDFE" =
               """
               Step C must be finished before step A can begin.
               Step C must be finished before step F can begin.
               Step A must be finished before step B can begin.
               Step A must be finished before step D can begin.
               Step B must be finished before step E can begin.
               Step D must be finished before step E can begin.
               Step F must be finished before step E can begin.
               """
               |> steps_in_order()
    end

    test_with_puzzle_input do
      assert "AEMNPOJWISZCDFUKBXQTHVLGRY" = puzzle_input() |> steps_in_order()
    end
  end
end
