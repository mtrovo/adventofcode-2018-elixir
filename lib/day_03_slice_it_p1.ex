defmodule Adventofcode2018.Rect do
  @enforce_keys [:pos, :size, :id]
  defstruct [:pos, :size, :id]

  def rect(id, pos, size) do
    %Adventofcode2018.Rect{id: id, pos: pos, size: size}
  end
end

defmodule Adventofcode2018.Point2D do
  defstruct [:x, :y]
end

defmodule Adventofcode2018.Day03SliceItP1 do
  use Adventofcode2018
  import Adventofcode2018.Rect
  import Adventofcode2018.Point2D

  def create_rect(id, x, y, w, h) do
    rect(
      id,
      %Adventofcode2018.Point2D{x: x, y: y},
      %Adventofcode2018.Point2D{x: w, y: h}
    )
  end

  def cross_prod([], _) do
    []
  end

  def cross_prod([a | as], bs) do
    Stream.map(bs, &{a, &1})
    |> Stream.concat(cross_prod(as, bs))
  end

  def square_points(rect) do
    with %Adventofcode2018.Point2D{x: x, y: y} <- rect.pos,
         %Adventofcode2018.Point2D{x: w, y: h} <- rect.size do
      a = Enum.to_list(x..(x + w - 1))
      b = Enum.to_list(y..(y + h - 1))
      cross_prod(a, b)
    end
  end

  def parse_input(str) do
    re = Regex.run(~r/#(\d+) \@ (\d+),(\d+): (\d+)x(\d+)/, str)

    if re == nil do
      raise("Invalid input " <> str)
    end

    {id, x, y, w, h} =
      re
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    create_rect(id, x, y, w, h)
  end

  def common_squares(input) do
    {_, repeated} =
      input
      |> String.split("\n")
      |> Enum.map(&parse_input/1)
      |> Enum.map(&square_points/1)
      |> Stream.concat()
      |> Enum.reduce({MapSet.new(), MapSet.new()}, fn v, {visited, repeated} ->
        repeated =
          if MapSet.member?(visited, v) do
            MapSet.put(repeated, v)
          else
            repeated
          end

        visited =
          if !MapSet.member?(visited, v) do
            MapSet.put(visited, v)
          else
            visited
          end

        {visited, repeated}
      end)

    MapSet.size(repeated)
  end
end
