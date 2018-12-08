defmodule Adventofcode2018.Day06ChronalCoordinatesP1 do
  use Adventofcode2018

  @ids ?A..?z |> Enum.map(&([&1] |> to_string |> String.to_atom()))

  def not_visited() do
    99999
  end

  def parse_line(line) do
    case Regex.run(~r/(\d+), (\d+)/, line) do
      nil -> raise("Could not parse line: " <> line)
      [_, x, y] -> [x, y] |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end
  end

  def bounding_box(cs, state \\ {9999, 9999, 0, 0})

  def bounding_box([], state) do
    state
  end

  def bounding_box([{cx, cy} | cs], {topx, topy, botx, boty}) do
    topx = if(cx < topx, do: cx, else: topx)
    botx = if(cx > botx, do: cx, else: botx)
    topy = if(cy < topy, do: cy, else: topy)
    boty = if(cy > boty, do: cy, else: boty)

    bounding_box(cs, {topx, topy, botx, boty})
  end

  def neighbours({x, y}, id, lvl) do
    [
      {{x, y + 1}, id, lvl},
      {{x, y - 1}, id, lvl},
      {{x + 1, y}, id, lvl},
      {{x - 1, y}, id, lvl}
    ]
  end

  def to_points({topx, topy, botx, boty}) do
    rx = topx..botx
    ry = topy..boty

    rx
    |> Enum.flat_map(fn x ->
      ry |> Enum.map(&{x, &1})
    end)
    |> Enum.into(%{}, &{&1, {-1, not_visited()}})
  end

  def ids_on_border({topx, topy, botx, boty}, filled_map) do
    [
      topx..botx
      |> Enum.flat_map(fn x ->
        [topy, boty]
        |> Enum.map(&{x, &1})
      end),
      topy..boty
      |> Enum.flat_map(fn y ->
        [topx, botx]
        |> Enum.map(&{&1, y})
      end)
    ]
    |> Enum.concat()
    |> Enum.map(&elem(filled_map[&1], 0))
    |> Enum.uniq()
  end

  def debug_map({topx, topy, botx, boty}, points) do
    topx..botx
    |> Enum.map(fn x ->
      topy..boty
      |> Enum.map(fn y ->
        case points[{x, y}] do
          {:repeat, _} -> "."
          {id, _} -> Atom.to_string(id)
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def id_freqs(vs, freq \\ %{})

  def id_freqs([], freq) do
    freq
  end

  def id_freqs([{id, _} | t], freq) do
    freq = Map.update(freq, id, 1, &(&1 + 1))
    id_freqs(t, freq)
  end

  def visit(points, {[], []}) do
    points
  end

  def visit(points, to_visit) do
    {{:value, {point, id, level}}, to_visit} = :queue.out(to_visit)

    if points[point] == nil do
      visit(points, to_visit)
    else
      {ts, h} = to_visit

      case points[point] do
        {_, clevel} when clevel < level ->
          visit(points, to_visit)

        {^id, ^level} ->
          visit(points, to_visit)

        {_, ^level} ->
          points = Map.put(points, point, {:repeat, level})
          visit(points, {ts, h})

        {_, clevel} when clevel > level ->
          points = Map.put(points, point, {id, level})
          visit(points, {neighbours(point, id, level + 1) ++ ts, h})
      end
    end
  end

  def largest_area(input) do
    coords =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)

    states = Enum.zip([coords, @ids, Stream.cycle([0])])

    bbox =
      states
      |> Enum.map(&elem(&1, 0))
      |> bounding_box()

    filled_map =
      bbox
      |> to_points()
      |> visit(:queue.from_list(states))

    debug_map(bbox, filled_map)

    id_freqs(Map.values(filled_map))
    |> Map.drop(ids_on_border(bbox, filled_map))
    |> Map.to_list()
    |> Enum.max_by(fn {_, v} -> v end)
    |> elem(1)
  end
end
