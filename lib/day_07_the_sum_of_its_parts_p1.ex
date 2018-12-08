defmodule Adventofcode2018.Day07TheSumOfItsPartsP1 do
  use Adventofcode2018

  def parse_line(line) do
    case Regex.run(~r/Step (\w).* step (\w)/, line) do
      nil -> raise("Error parsing line " <> line)
      [_, a, b] -> edge(a, b)
    end
  end

  @spec parse_input(binary()) :: [Adventofcode2018.Edge.t()]
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def build_graph(edges, g \\ %{}, inv_g \\ %{})
  def build_graph([], g, inv_g) do {g, inv_g} end
  def build_graph([e | edges], g, inv_g) do
    %Adventofcode2018.Edge{src: a, dst: b} = e
    g = g |> Map.update(a, [b], &([b | &1]))
    inv_g = inv_g |> Map.update(b, [a], &([a | &1]))
    build_graph(edges, g, inv_g)
  end

  def find_all_leaves(ks, g, visited \\ MapSet.new, leaves \\ [])
  def find_all_leaves([], _, _, leaves) do leaves end
  def find_all_leaves([k | ks], g, visited, leaves) do
    cond do
      MapSet.member?(visited, k) -> find_all_leaves(ks, g, visited, leaves)
      g[k] == nil -> find_all_leaves(ks, g, visited |> MapSet.put(k), [k | leaves])
      true -> find_all_leaves(ks ++ g[k], g, visited |> MapSet.put(k), leaves)
    end
  end

  def remove_edges(g, ns, src, emptys \\ [])
  def remove_edges(g, [], _, emptys) do {g, emptys} end
  def remove_edges(g, [n | ns], src, emptys) do
    g = Map.update(g, n, [], &(List.delete(&1, src)))
    if g[n] == [] do
      g = Map.delete(g, n)
      remove_edges(g, ns, src, [n | emptys])
    else
      remove_edges(g, ns, src, emptys)
    end
  end

  def topo_sort(vs, g, invg, ac \\ [])
  def topo_sort([], _, _, ac) do ac end
  def topo_sort([v | to_visit], g, invg, ac) do
    ac = [v | ac]

    {invg, empty_nodes} = remove_edges(invg, Map.get(g, v, []), v)
    to_visit = (to_visit ++ empty_nodes) |> Enum.sort
    topo_sort(to_visit, g, invg, ac)
  end

  def steps_in_order(input) do
    {g, inv_g} = input
    |> parse_input
    |> build_graph

    firsts = find_all_leaves(Map.keys(g), inv_g)
    |> Enum.sort

    topo_sort(firsts, g, inv_g)
    |> Enum.reverse
    |> Enum.join("")
  end
end
