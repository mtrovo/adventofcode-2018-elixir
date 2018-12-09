defmodule Adventofcode2018.Day08MemoryManeuverP2 do
  use Adventofcode2018
  import Adventofcode2018.Day08MemoryManeuverP1

  defmodule TreeNode do
    defstruct [:children, :metadata]
  end

  def treenode(children, metadata) do
    %TreeNode{children: children, metadata: metadata}
  end

  def parse_nodes_tree(input, nodes \\ [])

  def parse_nodes_tree([], nodes) do
    {[], nodes}
  end

  def parse_nodes_tree([nr_child, metadata_size | tail], nodes) do
    {tail, nodes} =
      if nr_child > 0 do
        1..nr_child
        |> Enum.reduce({tail, nodes}, fn _, {t, n} -> parse_nodes_tree(t, n) end)
      else
        {tail, nodes}
      end

    {metadata, tail} = Enum.split(tail, metadata_size)
    {children, nodes} = nodes |> Enum.split(nr_child)
    children = children |> Enum.reverse()
    {tail, [treenode(children, metadata) | nodes]}
  end

  def build_tree(input) do
    {_, [node]} = parse_nodes_tree(input)
    node
  end

  def sum_tree(node) do
    if length(node.children) == 0 do
      node.metadata |> Enum.sum()
    else
      node.metadata
      |> Enum.map(&Enum.at(node.children, &1 - 1, nil))
      |> Enum.filter(&(&1 != nil))
      |> Enum.map(&sum_tree/1)
      |> Enum.sum()
    end
  end

  def root_node_value(input) do
    input
    |> parse_input
    |> build_tree
    |> sum_tree
  end
end
