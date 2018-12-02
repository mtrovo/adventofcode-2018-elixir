defmodule Adventofcode2018.Day01ChronalCalibrationP2 do
  use Adventofcode2018
  def inf_stream(input) do
    input 
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> Stream.cycle
    |> Stream.scan(0, &(&1+&2))
  end
  
  def first_duplicate(input) do
    input
    |> inf_stream
    |> Enum.reduce_while(%{0=>true}, fn (v, ac) ->
      if ac[v] == nil do
        {:cont, Map.put(ac, v, 1)}
      else
        {:halt, v}
      end
    end)
  end
end
