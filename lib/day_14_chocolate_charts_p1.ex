defmodule Adventofcode2018.Day14ChocolateChartsP1 do
  use Adventofcode2018

  def build_initial(initial) do
    initial
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.into(%{}, fn {c, i} ->
      {i, String.to_integer(c)}
    end)
  end

  def ff(stream, scores) do
    stream
    |> Stream.drop_while(fn game ->
      game.current_index < scores
    end)
  end

  def tick(game) do
    scores =
      game.elves
      |> Enum.map(&game[&1])
      |> Enum.sum()
      |> Integer.digits()

    newgame =
      scores
      |> Enum.with_index(game.current_index)
      |> Enum.reduce(game, fn {score, i}, game ->
        game
        |> Map.put(i, score)
        |> Map.put(:current_index, i + 1)
      end)
      |> Map.put(:delta, length(scores))

    newpos =
      game.elves
      |> Enum.map(&rem(&1 + newgame[&1] + 1, newgame.current_index))

    %{newgame | elves: newpos}
  end

  def fill_indexes(stream) do
    stream
    |> Stream.flat_map(fn game ->
      case game.delta do
        1 ->
          [game]

        n ->
          (game.current_index - (n - 1))..game.current_index
          |> Enum.map(fn idx ->
            %{game | current_index: idx}
          end)
      end
    end)
  end

  def make_stream(game) do
    Stream.iterate(game, &tick/1)
    |> fill_indexes()
  end

  def debug_state(game) do
    0..game.current_index
    |> Enum.map(&Map.get(game, &1))
    |> Enum.join(" ")
    |> IO.inspect(label: "current state")

    game
  end

  def take_last(stream, n) do
    game =
      stream
      |> Enum.take(1)
      |> hd
      |> debug_state

    (game.current_index - n)..(game.current_index - 1)
    |> Enum.map(&Map.get(game, &1))
  end

  def ten_recipes_after(input, initial) do
    game =
      build_initial(initial)
      |> Map.put(:current_index, String.length(initial))
      |> Map.put(:elves, [0, 1])
      |> Map.put(:delta, 1)

    n = String.to_integer(input)

    game
    |> make_stream
    |> ff(n + 10)
    |> take_last(10)
    |> Enum.join("")
  end
end
