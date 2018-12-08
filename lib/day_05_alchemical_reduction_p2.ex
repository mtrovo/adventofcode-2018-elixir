defmodule Adventofcode2018.Day05AlchemicalReductionP2 do
  use Adventofcode2018
  import Adventofcode2018.Day05AlchemicalReductionP1

  def remove_letter([], _) do [] end
  def remove_letter([c | cs], rm) when c - rm |> abs == 32 do remove_letter(cs, rm) end
  def remove_letter([c | cs], c) do remove_letter(cs, c) end
  def remove_letter([c | cs], rm) do
    [c | remove_letter(cs, rm)]
  end

  def rm_unit_length(input) do
    polymer = input
    |> String.trim
    |> String.to_charlist

    ?a..?z
    |> Enum.to_list
    |> Stream.map(&remove_letter(polymer, &1))
    |> Stream.map(&react_length/1)
    |> Enum.min
  end
end
