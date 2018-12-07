defmodule Adventofcode2018.Day06ChronalCoordinatesP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day06ChronalCoordinatesP2
  describe "region_area/1" do
    test "sample input" do
      assert 16 = """
      1, 1
      1, 6
      8, 3
      3, 4
      5, 5
      8, 9
      """ |> region_area(32)
    end

    test_with_puzzle_input do
      assert 42123 = puzzle_input() |> region_area(10_000)
    end
  end
end
