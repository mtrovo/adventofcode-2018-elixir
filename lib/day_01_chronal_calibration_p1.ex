defmodule Adventofcode2018.Day01ChronalCalibrationP1 do
  use Adventofcode2018

  def sum(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(0, &(&1 + &2))
  end
end
