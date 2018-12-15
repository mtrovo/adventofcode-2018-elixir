defmodule Adventofcode2018.Day09MarbleManiaP2 do
  use Adventofcode2018
  import Adventofcode2018.Day09MarbleManiaP1

  def highscore_x100(input) do
    game = input |> parse_input
    game = %Adventofcode2018.Day09MarbleManiaP1.Game{game | last_marble: game.last_marble * 100}

    play_marbles(
      1..game.players
      |> Stream.cycle()
      |> Enum.take(game.last_marble)
      |> Enum.to_list(),
      1..game.last_marble
      |> Enum.to_list()
    )
    |> Map.values()
    |> Enum.max()
  end
end
