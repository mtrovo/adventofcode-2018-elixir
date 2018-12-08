defmodule Adventofcode2018.Day04ReposeRecordP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day04ReposeRecordP1

  describe "input_type/1" do
    test "identify begins instruction" do
      assert :begins = input_type("[1518-09-27 00:02] Guard #617 begins shift")
    end

    test "identify asleep instruction" do
      assert :sleeps = input_type("[1518-11-11 00:05] falls asleep")
    end

    test "identify wakeup instruction" do
      assert :wakes = input_type("[1518-07-28 00:56] wakes up")
    end
  end

  describe "parse_begins/1" do
    test "return struct when success" do
      assert %Adventofcode2018.GuardBegins{id: 617} =
               parse_begins("[1518-09-27 00:02] Guard #617 begins shift")
    end
  end

  describe "parse_sleeps/1" do
    test "return struct when success" do
      assert %Adventofcode2018.GuardAsleep{min: 5} =
               parse_sleeps("[1518-11-11 00:05] falls asleep")
    end
  end

  describe "parse_wakes/1" do
    test "return struct when success" do
      assert %Adventofcode2018.GuardAwake{min: 56} = parse_wakes("[1518-07-28 00:56] wakes up")
    end
  end

  describe "sum_minutes/1" do
    test "return sum for single range" do
      assert {1, 10} = sum_minutes(%{id: 1, sleeps: [10..20]})
    end

    test "return sum for multi range" do
      assert {1, 20} = sum_minutes(%{id: 1, sleeps: [10..20, 40..50]})
    end
  end

  describe "freq_map/1" do
    test "return frequency map on success" do
      assert %{a: 1, c: 2, e: 3} = freq_map([:a, :e, :e, :c, :e, :c])
    end
  end

  describe "aggr_input/2" do
    test "valid shift" do
      assert %{cur_shift: %{id: 1, sleeps: [25..29, 1..9]}} =
               [
                 %Adventofcode2018.GuardBegins{id: 1},
                 %Adventofcode2018.GuardAsleep{min: 1},
                 %Adventofcode2018.GuardAwake{min: 10},
                 %Adventofcode2018.GuardAsleep{min: 25},
                 %Adventofcode2018.GuardAwake{min: 30}
               ]
               |> Enum.reduce(%Adventofcode2018.ParseState{}, &aggr_input/2)
    end
  end

  describe "guard_id_minute/1" do
    test_with_puzzle_input do
      assert 8950 = puzzle_input() |> guard_id_minute()
    end
  end
end
