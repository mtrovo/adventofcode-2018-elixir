defmodule Adventofcode2018.Day09MarbleManiaP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day09MarbleManiaP1

  describe "parse_input/1" do
    test "return input data" do
      game = game(9, 25)
      assert ^game = "9 players; last marble is worth 25 points" |> parse_input
    end
  end

  describe "highest_score/1" do
    test "sample input" do
      assert 32 = "9 players; last marble is worth 25 points" |> highest_score()
    end

    test "extra sample inputs" do
      assert 8317 = "10 players; last marble is worth 1618 points" |> highest_score()
      assert 146_373 = "13 players; last marble is worth 7999 points" |> highest_score()
      assert 2764 = "17 players; last marble is worth 1104 points" |> highest_score()
      assert 54718 = "21 players; last marble is worth 6111 points" |> highest_score()
      assert 37305 = "30 players; last marble is worth 5807 points" |> highest_score()
    end

    test_with_puzzle_input do
      assert 425688 = puzzle_input() |> highest_score()
    end
  end
end
