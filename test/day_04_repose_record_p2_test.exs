defmodule Adventofcode2018.Day04ReposeRecordP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day04ReposeRecordP2
  describe "most_freq_minute/1" do
    test_with_puzzle_input do
      assert 78452 = puzzle_input() |> most_freq_minute()
    end
  end
end
