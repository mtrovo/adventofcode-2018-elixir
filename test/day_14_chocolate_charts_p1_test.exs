defmodule Adventofcode2018.Day14ChocolateChartsP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day14ChocolateChartsP1

  describe "ten_recipes_after/1" do
    test "sample input" do
      assert "5158916779" = "9" |> ten_recipes_after("37")
    end

    test_with_puzzle_input do
      assert "9211134315" = puzzle_input() |> ten_recipes_after("37")
    end
  end
end
