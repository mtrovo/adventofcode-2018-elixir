defmodule Adventofcode2018.Day13MineCartMadnessP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day13MineCartMadnessP2

  def sample_input do
    """
    />-<\\
    |   |
    | /<+-\\
    | | | v
    \\>+</ |
      |   ^
      \\<->/
    """
  end

  describe "last_cart_pos/1" do
    test "sample input" do
      assert {6, 4} = sample_input() |> last_cart_pos()
    end

    test_with_puzzle_input do
      assert 1337 = puzzle_input() |> last_cart_pos()
    end
  end
end
