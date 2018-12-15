defmodule Adventofcode2018.Day11ChronalChargeP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day11ChronalChargeP2

  describe "max_sum_square/1" do
    test "sample input" do
      assert {90, 269, 16} = "18" |> max_sum_square()
    end

    test_with_puzzle_input do
      assert {233, 40, 13} = puzzle_input() |> max_sum_square()
    end
  end
end
