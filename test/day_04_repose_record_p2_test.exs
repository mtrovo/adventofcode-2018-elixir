defmodule Adventofcode2018.Day04ReposeRecordP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day04ReposeRecordP2

  describe "id_min/1" do
    test "list with single range" do
      assert [{1, 10}, {1, 11}] = id_min(%{id: 1, sleeps: [10..11]})
        |> Enum.to_list
    end
  end
  describe "most_freq_minute/1" do
    test_with_puzzle_input do
      assert 78452 = puzzle_input() |> most_freq_minute()
    end
  end
end
