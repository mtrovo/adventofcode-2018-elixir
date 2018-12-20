defmodule Adventofcode2018.Day14ChocolateChartsP2 do
  use Adventofcode2018
  import Adventofcode2018.Day14ChocolateChartsP1

  def map_suffix_into_num(stream, digits) do
    stream
    |> Stream.scan(:init, fn
      game, :init ->
        num =
          (game.current_index - digits)..(game.current_index - 1)
          |> Enum.map(&game[&1])
          |> Integer.undigits()

        {game, num}

      game, {_, ac} ->
        remh = rem(ac, trunc(:math.pow(10, digits - 1)))
        num = remh * 10 + game[game.current_index - 1]
        # IO.inspect({game.current_index, num}, label: "Result on gen")
        {game, num}
    end)
  end

  def find_suffix(stream, num) do
    stream
    |> Stream.drop_while(fn {_, sum} ->
      sum != num
    end)
    |> Enum.take(1)
    |> hd
    |> elem(0)
  end

  def recipes_before_sequence(input, initial, digits \\ nil) do
    game =
      build_initial(initial)
      |> Map.put(:current_index, String.length(initial))
      |> Map.put(:elves, [0, 1])
      |> Map.put(:delta, 1)

    n = String.to_integer(input)

    digs =
      if digits == nil do
        Integer.digits(n)
        |> length
      else
        digits
      end

    ff_game =
      game
      |> make_stream
      |> ff(digs)
      |> map_suffix_into_num(digs)
      |> find_suffix(n)

    ff_game.current_index - digs
  end
end
