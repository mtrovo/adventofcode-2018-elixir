defmodule Adventofcode2018.Day14ChocolateChartsP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day14ChocolateChartsP2

  describe "recipes_before_sequence/1" do
    test "sample input" do
      assert 2018 = "59414" |> recipes_before_sequence("37")
      assert 9 = "51589" |> recipes_before_sequence("37")
      assert 5 = "01245" |> recipes_before_sequence("37", 5)
      assert 18 = "92510" |> recipes_before_sequence("37")
    end

    test_with_puzzle_input do
      assert 20357548 = "077201" |> recipes_before_sequence("37", 6)
    end
  end
end
