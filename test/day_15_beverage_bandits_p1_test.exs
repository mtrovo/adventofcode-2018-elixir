defmodule Adventofcode2018.Day15BeverageBanditsP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day15BeverageBanditsP1

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

  describe "parse_input/2" do
    test "return correct battle" do
      assert %{
               units: %{
                 {2, 1} => %{health: 200, type: "G"},
                 {3, 4} => %{health: 200, type: "G"},
                 {4, 2} => %{health: 200, type: "E"},
                 {5, 2} => %{health: 200, type: "G"},
                 {5, 3} => %{health: 200, type: "G"},
                 {5, 4} => %{health: 200, type: "E"}
               }
             } =
               sample_input()
               |> parse_input(%{ap: %{"G" => 3, "E" => 3}})
    end
  end

  describe "path/4" do
    test "return correct map of distances" do
      battle = sample_input() |> parse_input(%{ap: %{"G" => 3, "E" => 3}})
      pos = {2, 1}
      unit = battle.units[pos]
      dist_map = path(pos, unit, battle.units, battle.map)

      assert """
             #######   \n\
             #4G212#   G(200)
             #321EG#   E(200)G(200)
             #4#2#G#   G(200)
             #55G#E#   G(200)E(200)
             #54321#   \n\
             #######   \
             """ = strboard(battle, dist_map)
    end
  end

  describe "checksum_endgame/1" do
    test "sample input" do
      assert 27730 =
               sample_input()
               |> checksum_endgame()
    end

    test "sample input 2" do
      assert 36334 =
               """
               #######
               #G..#E#
               #E#E.E#
               #G.##.#
               #...#E#
               #...E.#
               #######
               """
               |> checksum_endgame()
    end

    test_with_puzzle_input do
      assert 228_240 = puzzle_input() |> checksum_endgame()
    end
  end
end
