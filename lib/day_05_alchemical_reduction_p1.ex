defmodule Adventofcode2018.Day05AlchemicalReductionP1 do
  use Adventofcode2018

  def react_pass(cs, res \\ [])

  def react_pass([], res) do
    res
  end

  def react_pass([a, b | cs], res) when abs(a - b) == 32 do
    react_pass(cs, res)
  end

  def react_pass([a | cs], res) do
    react_pass(cs, [a | res])
  end

  def react(cs) do
    case react_pass(cs) |> Enum.reverse() do
      ^cs -> cs
      newcs -> react(newcs)
    end
  end

  def react_length(cs) do
    cs
    |> react
    |> length
  end

  def polymer_size(input) do
    input
    |> String.trim()
    |> String.to_charlist()
    |> react_length
  end
end
