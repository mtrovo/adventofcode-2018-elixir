defmodule Adventofcode2018.Day06ChronalCoordinatesP2 do
  use Adventofcode2018
  import Adventofcode2018.Day06ChronalCoordinatesP1

  @ids ?A..?z |> Enum.map(&([&1] |> to_string |> String.to_atom))

  def visit_total_sum(points, to_visit, visited \\ MapSet.new) 
  def visit_total_sum(points, {[], []}, _) do points end
  def visit_total_sum(points, to_visit, visited) do
    {{:value, {pos, id, dist}}, to_visit} = :queue.out(to_visit)
    
    {ts, h} = to_visit
    cond do
      points[pos] == nil -> visit_total_sum(points, to_visit, visited)
      MapSet.member?(visited, pos) -> visit_total_sum(points, to_visit, visited)
      true ->
        points = Map.update!(points, pos, &(&1+dist))
        to_visit = {neighbours(pos, id, dist+1) ++ ts, h}
        visit_total_sum(points, to_visit, MapSet.put(visited, pos))
    end
  end

  def to_points_map({topx, topy, botx, boty}) do
    rx = topx..botx
    ry = topy..boty
    
    rx
    |> Enum.flat_map(fn x ->
      ry |> Enum.map(&({x,&1}))
    end)
    |> Enum.into(%{}, &({&1, 0}))
  end

  def region_area(input, limit) do
    coords = input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    
    states = Enum.zip([coords, @ids, Stream.cycle([0])])

    bbox = coords
    |> bounding_box()

    points = bbox
    |> to_points_map()

    states
    |> Enum.reduce(points, &(visit_total_sum(&2, :queue.from_list([&1]))))
    |> Map.to_list
    |> Enum.count(fn{_, v} -> v < limit end)
  end
end
