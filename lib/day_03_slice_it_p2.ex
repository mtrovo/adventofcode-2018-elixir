defmodule Adventofcode2018.Day03SliceItP2 do
  use Adventofcode2018
  import Adventofcode2018.Day03SliceItP1

  def reduce_with_id({_, []}, {visited, id_visited, dup}) do {visited, id_visited, dup} end
  def reduce_with_id({id, [p|ps]}, {visited, id_visited, dup}) do
    dup = if visited[p] != nil do
      dup
      |> MapSet.put(id)
      |> MapSet.put(visited[p])
    else
      dup
    end

    visited = if visited[p] == nil do
      visited
      |> Map.put(p, id)
    else
      visited
    end

    id_visited = id_visited
    |> MapSet.put(id)

    reduce_with_id({id, ps}, {visited, id_visited, dup})
  end

  def non_overlapping_id(input) do
    {_,vis, dup} = input
    |> String.split("\n")
    |> Enum.map(&parse_input/1)
    |> Enum.map(&({&1.id, Enum.to_list(square_points(&1))}))
    |> Enum.reduce({%{}, MapSet.new(), MapSet.new()}, &reduce_with_id/2)
    
    MapSet.difference(vis, dup)
    |> MapSet.to_list
    |> hd
  end
end
