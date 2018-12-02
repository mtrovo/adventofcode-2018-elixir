defmodule Adventofcode2018.Day01ChronalCalibrationP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day01ChronalCalibrationP1

  describe "sum/1" do
    test "positive sum" do
      assert 3 = "+1 +1 +1" |> sum()
    end

    test "negative sum" do
      assert -3 = "-1 -1 -1" |> sum()
    end

    test_with_puzzle_input do
      assert 437 = puzzle_input() |> sum()
    end
  end
end
