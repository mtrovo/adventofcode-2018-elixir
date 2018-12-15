defmodule Adventofcode2018.Day11ChronalChargeP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day11ChronalChargeP1

  describe "fuel_level/2" do
    test "return correct fuel level" do
      assert -5 = fuel_level({122, 79}, 57)
      assert 0 = fuel_level({217, 196}, 39)
      assert 4 = fuel_level({101, 153}, 71)
    end
  end

  describe "new_grid/2" do
    test "create a grid with a 2d list" do
      assert [[-3, -3, -3], [-2, -1, -1], [-1, 0, 1]] = new_grid(10, 3)
    end
  end

  describe "calc_sums_line/2" do
    test "all sums in line" do
      assert [6, 9, 12, 15, 16, 15, 12, 9, 6] =
               calc_sums_line([1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1], 3)
    end
  end

  describe "calc_sum_square/2" do
    test "sum when grid side == size" do
      assert [[27]] =
               calc_sum_square(
                 [
                   [1, 2, 3],
                   [2, 3, 4],
                   [3, 4, 5]
                 ],
                 3
               )
    end

    test "all sums available for given side" do
      assert [
               [27, 33, 24],
               [40, 34, 22],
               [31, 26, 17]
             ] =
               calc_sum_square(
                 [
                   [1, 2, 3, 9, 0],
                   [2, 3, 4, 1, 0],
                   [3, 4, 5, 2, 0],
                   [9, 5, 5, 5, 0],
                   [0, 0, 0, 0, 0]
                 ],
                 3
               )
    end
  end

  describe "max_sum_coord/1" do
    assert {1, 1} = max_sum_coord([[9, 4, 3], [1, 2, 3], [5, 8, 7]])
  end

  describe "max_3x3_coord/1" do
    test "sample input" do
      assert {33, 45} = "18" |> max_3x3_coord()
    end

    test_with_puzzle_input do
      assert {235, 85} = puzzle_input() |> max_3x3_coord()
    end
  end
end
