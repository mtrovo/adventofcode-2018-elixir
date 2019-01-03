defmodule Adventofcode2018.Day15BeverageBanditsP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day15BeverageBanditsP2

  def sample_input do
    """
    #######
    #.G...#
    #...EG#
    #.#.#G#
    #..G#E#
    #.....#
    #######
    """
    |> String.trim()
  end

  describe "checksum_nodeaths/1" do
    test "sample input" do
      assert 4988 = sample_input() |> checksum_nodeaths()
    end

    test_with_puzzle_input do
      assert 52626 = puzzle_input() |> checksum_nodeaths()
    end
  end
end
