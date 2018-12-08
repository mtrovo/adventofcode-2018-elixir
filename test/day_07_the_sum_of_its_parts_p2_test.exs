defmodule Adventofcode2018.Day07TheSumOfItsPartsP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day07TheSumOfItsPartsP2

  describe "cost/2" do
    test "cost with zero initial" do
      assert 1 = cost(0, "A")
    end

    test "cost with non zero initial" do
      assert 102 = cost(100, "B")
    end
  end

  describe "sub_elapsed_time/2" do
    test "subtract from all" do
      assert %{
        "C" => 35,
        "A" => 22,
        "F" => 77,
        "D" => 0
      } = sub_elapsed_time(%{
        "C" => 65,
        "A" => 52,
        "F" => 107,
        "D" => 30
      }, 30)
    end
  end

  describe "find_min_cost/1" do
    test "return minimum cost for current workers" do
      assert {"C", 35} = find_min_cost(%{
        "C" => 35,
        "A" => 99,
        "F" => 77
      })
    end
  end

  describe "total_duration/1" do
    test "sample input" do
      assert 15 = """
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.
      """ |> total_duration(0, 2)
    end

    test_with_puzzle_input do
      assert 1337 = puzzle_input() |> total_duration(60, 5)
    end
  end
end
