defmodule Adventofcode2018.Day12SubterraneanSustainabilityP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day12SubterraneanSustainabilityP1

  describe "parse_initial/1" do
    test "return map with correct start and data" do
      assert %{start: 0, data: [0, 1, 0, 0]} =
               "initial state: .#.."
               |> parse_initial
    end
  end

  describe "parse_rule/1" do
    test "return rule as kv pair" do
      assert {3, 1} =
               "...## => #"
               |> parse_rule
    end
  end

  describe "parse_input/1" do
    test "parse input and return map with rules and initial state" do
      assert %{
               state: %{
                 start: 0,
                 data: [1, 0, 0, 1, 0]
               },
               rules: %{
                 3 => 1,
                 4 => 1
               }
             } =
               """
               initial state: #..#.

               ...## => #
               ..#.. => #
               """
               |> parse_input
    end
  end

  describe "do_update_generation/5" do
    test "return correct next generation" do
      data = [0, 0, 0, 0, 1]

      assert %{data: [0, 0, 0, 0, 0, 1, 0, 0, 0]} =
               update_generation(%{
                 state: %{data: data, start: 0, curgen: 0},
                 rules: %{2 => 1},
                 stable: false
               })
    end
  end

  describe "trim_state/1" do
    test "trim left" do
      assert %{start: -1, data: [1, 0, 0, 1]} =
               %{start: -3, data: [0, 0, 1, 0, 0, 1]}
               |> trim_state
    end

    test "trim right" do
      assert %{start: -3, data: [1, 0, 0, 1]} =
               %{start: -3, data: [1, 0, 0, 1, 0, 0]}
               |> trim_state
    end

    test "trim both" do
      assert %{start: -1, data: [1, 0, 0, 1]} =
               %{start: -3, data: [0, 0, 1, 0, 0, 1, 0, 0, 0]}
               |> trim_state
    end
  end

  describe "sum_pots/1" do
    test "sample input" do
      IO.puts("\n\n")

      assert 325 =
               """
                     initial state: #..#.#..##......###...###

                     ...## => #
                     ..#.. => #
                     .#... => #
                     .#.#. => #
                     .#.## => #
                     .##.. => #
                     .#### => #
                     #.#.# => #
                     #.### => #
                     ##.#. => #
                     ##.## => #
                     ###.. => #
                     ###.# => #
                     ####. => #
               """
               |> sum_pots(20)
    end

    test_with_puzzle_input do
      assert 4818 = puzzle_input() |> sum_pots(20)
    end
  end
end
