defmodule Adventofcode2018.Day04ReposeRecordP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day04ReposeRecordP1
  describe "guard_id_minute/1" do
    test_with_puzzle_input do
      assert 8950 = puzzle_input() |> guard_id_minute()
    end
  end
end
