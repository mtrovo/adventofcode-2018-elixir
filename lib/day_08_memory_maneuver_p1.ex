defmodule Adventofcode2018.Day08MemoryManeuverP1 do
  use Adventofcode2018

  defmodule Node do
    defstruct [:nr_child, :metadata]
  end

  def node(nr_child, metadata) do
    %Node{nr_child: nr_child, metadata: metadata}
  end

  def parse_input(input) do
    input
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_nodes(input, nodes \\ [])

  def parse_nodes([], nodes) do
    {[], nodes}
  end

  def parse_nodes([childs, metadata_size | tail], nodes) do
    {tail, nodes} =
      if childs > 0 do
        1..childs
        |> Enum.reduce({tail, nodes}, fn _, {t, n} -> parse_nodes(t, n) end)
      else
        {tail, nodes}
      end

    {metadata, tail} = Enum.split(tail, metadata_size)
    {tail, [node(childs, metadata) | nodes]}
  end

  def nodes(input) do
    {_, nodes} = parse_nodes(input)
    nodes
  end

  def metadata_sum(input) do
    input
    |> parse_input
    |> nodes
    |> Enum.flat_map(& &1.metadata)
    |> Enum.sum()
  end
end
