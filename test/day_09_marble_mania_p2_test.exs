defmodule Adventofcode2018.Day09MarbleManiaP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day09MarbleManiaP2

  describe "highscore_x100/1" do
    test_with_puzzle_input do
      assert 3_526_561_003 = puzzle_input() |> highscore_x100()
    end
  end
end
