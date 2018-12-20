defmodule Adventofcode2018.Day12SubterraneanSustainabilityP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day12SubterraneanSustainabilityP2

  describe "sum_1500y/1" do
    test_with_puzzle_input do
      assert 5_100_000_001_377 = puzzle_input() |> sum_1500y()
    end
  end
end
