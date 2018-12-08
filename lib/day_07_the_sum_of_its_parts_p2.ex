defmodule Adventofcode2018.Day07TheSumOfItsPartsP2 do
  use Adventofcode2018
  import Adventofcode2018.Day07TheSumOfItsPartsP1

  def cost(ini, id) do
    ini - ?A + 1 + (id
    |> to_charlist()
    |> hd)
  end

  def find_min_cost(working_times) do
    working_times
    |> Map.to_list
    |> Enum.min_by(&(elem(&1, 1)))
  end

  def sub_elapsed_time(working_times, sub) do
    working_times
    |> Map.keys
    |> Enum.reduce(working_times,
      &(Map.update!(&2, &1, fn curval -> curval - sub end)))
  end

  def calc_duration(vs, g, ig, ini_delay, max_workers,
  working_times \\ %{}, total_duration \\ 0)
  def calc_duration([], _, _, _, _, times, total_duration)
  when times == %{} do total_duration end
  def calc_duration(vs, g, invg, ini_delay, max_workers,
  working_times, total_duration) do
    {working_times, vs} = if Map.size(working_times) < max_workers do
      diff = max_workers - Map.size(working_times)
      working_times = vs
      |> Enum.take(diff)
      |> Enum.reduce(working_times, &(Map.put(&2, &1, cost(ini_delay, &1))))
      vs = vs |> Enum.drop(diff)
      {working_times, vs}
    else
      {working_times, vs}
    end

    {id, mincost} = find_min_cost(working_times)
    total_duration = total_duration + mincost
    working_times = sub_elapsed_time(working_times, mincost)
    working_times = Map.delete(working_times, id)

    {invg, empty_nodes} = remove_edges(invg, Map.get(g, id, []), id)
    vs = (vs ++ empty_nodes) |> Enum.sort
    calc_duration(vs, g, invg, ini_delay, max_workers, working_times, total_duration)
  end

  def total_duration(input, ini_delay, workers) do
    {g, ig} = input
    |> parse_input
    |> build_graph

    firsts = find_all_leaves(Map.keys(g), ig)
    |> Enum.sort

    calc_duration(firsts, g, ig, ini_delay, workers)
  end
end
