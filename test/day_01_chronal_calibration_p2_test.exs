defmodule Adventofcode2018.Day01ChronalCalibrationP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day01ChronalCalibrationP2

  describe "first_duplicate/1" do
    test "duplicate in cycle" do
      assert 10 = "+10 +10 +10 -29" |> first_duplicate()
    end

    test "duplicate in zero" do
      assert 0 = "+1 +1 -3" |> first_duplicate()
    end

    test_with_puzzle_input do
      assert 655 = puzzle_input() |> first_duplicate()
    end
  end
end
