defmodule Adventofcode2018.Day03SliceItP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day03SliceItP2
  describe "non_overlapping_id/1" do
    test "non overlapping with 1 rect" do
      assert 1 = "#1 @ 749,666: 27x15" |> non_overlapping_id()
    end
    test_with_puzzle_input do
      assert 806 = puzzle_input() |> non_overlapping_id()
    end
  end
end
