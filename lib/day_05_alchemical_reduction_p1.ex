defmodule Adventofcode2018.Day05AlchemicalReduction do
  use Adventofcode2018

  def pos_repeated(cs, last \\ ?0, pos \\ 0)
  def pos_repeated([c|_], last, pos) when c - last |> abs == 32 do pos-1 end
  def pos_repeated([], _, _) do :not_found end
  def pos_repeated([c|cs], _, pos) do
    pos_repeated(cs, c, pos+1)
  end

  def react(cs) do
    case pos_repeated(cs) do
      :not_found -> cs
      pos -> (cs |> Enum.take(pos)) ++ (cs |> Enum.drop(pos+2))
        |> react
    end
  end

  def polymer_size(input) do
    polymer = input
    |> String.trim
    |> String.to_charlist

    polymer
    |> react
    |> length
  end
end
