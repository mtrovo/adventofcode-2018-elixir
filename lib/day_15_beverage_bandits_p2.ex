defmodule Adventofcode2018.Day15BeverageBanditsP2 do
  use Adventofcode2018
  import Adventofcode2018.Day15BeverageBanditsP1

  def stream_game(input, elf_atk) do
    opts = %{ap: %{"G" => elf_atk, "E" => 3}, debug: false}

    initial =
      input
      |> parse_input(opts)

    {battle, turn} =
      initial
      |> Stream.iterate(&tick/1)
      |> Stream.map(&inspectb(&1, %{}, opts))
      |> Stream.with_index()
      |> Stream.drop_while(&(!Map.get(elem(&1, 0), :gameover)))
      |> Enum.take(1)
      |> hd

    {initial, battle, turn}
  end

  def count_elves(battle) do
    battle.units
    |> Map.values()
    |> Enum.filter(&(&1.type == "E"))
    |> Enum.count()
  end

  def elf_deaths?({initial, battle, _}) do
    count_elves(initial) > count_elves(battle)
  end

  def checksum_nodeaths(input) do
    {_, battle, turn} =
      3..300
      |> Stream.map(&stream_game(input, &1))
      |> Stream.drop_while(&elf_deaths?/1)
      |> Enum.take(1)
      |> hd

    sumh =
      battle.units
      |> Map.values()
      |> Enum.map(& &1.health)
      |> Enum.sum()

    turn =
      case battle.gameover do
        :partial -> turn - 1
        :full -> turn
        _ -> raise("invalid state")
      end

    sumh * turn
  end
end
