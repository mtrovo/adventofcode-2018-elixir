defmodule Adventofcode2018.Day10TheStarsAlignP1 do
  use Adventofcode2018

  def parse_line(line) do
    [x,y, vx,vy] = case Regex.run(~r/position=<\s?(-?\d+), \s?(-?\d+)> velocity=<\s?(-?\d+), \s?(-?\d+)>/, line) do
      nil -> raise("error parsing line "<>line)
      [_,x,y, vx,vy] -> [x,y, vx,vy] |> Enum.map(&String.to_integer/1)
    end
    {{x,y}, {vx,vy}}
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def next(points) do
      result = points
      |> Enum.map(fn {{x,y}, {vx,vy}} ->
        {{x+vx, y+vy}, {vx,vy}}
      end)
      result
  end

  def play_stream(points) do
    Stream.iterate(points, &next/1)
  end

  def sky_aligned(points) do
    pos = points |> Enum.map(&elem(&1, 0))
    {_, ty, _, by} = pos |> bounding_box()
    height = by - ty + 1

    # shortcircuit for big heights
    if height > 20 do
      false
    else
      freqs = pos
      |> Enum.uniq
      |> Enum.map(&elem(&1, 0))
      |> freq_map
      |> Map.values
      |> freq_map

      Map.get(freqs, height, 0) > 2
    end
  end

  def sky_string(points) do
    points = points |> Enum.map(&elem(&1, 0))
    {tx, ty, bx, by} = bounding_box(points)
    fsize = (bx-tx) * (by-ty)
    if fsize > 10_000 do
      "ERR: Field too big!" <> to_string(fsize)
    else

      points = points |> MapSet.new

      ty..by
      |> Enum.map(fn y ->
        tx..bx
        |> Enum.map(fn x ->
          if MapSet.member?(points, {x,y}) do
            "#"
          else
            "."
          end
        end)
        |> Enum.join(" ")
      end)
      |> Enum.join("\n")
    end
  end

  def sky_message(input) do
    input |> parse_input
    |> play_stream
    |> Stream.drop_while(&(not sky_aligned(&1)))
    |> Enum.take(1)
    |> hd
    |> sky_string
  end
end
