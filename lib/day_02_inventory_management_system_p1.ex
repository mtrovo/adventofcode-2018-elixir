defmodule Adventofcode2018.Day02InventoryManagementSystemP1 do
  use Adventofcode2018

  def inv_freq(id) do
    id
    |> String.graphemes()
    |> freq_map
    |> Map.values()
    |> freq_map
  end

  def freq_2_3(freq) do
    [if(freq[2], do: 1, else: 0), if(freq[3], do: 1, else: 0)]
  end

  def checksum(input) do
    {f2, f3} =
      input
      |> String.split()
      |> Enum.map(&inv_freq/1)
      |> Enum.map(&freq_2_3/1)
      |> Enum.zip()
      |> Enum.map(fn vs ->
        Tuple.to_list(vs)
        |> Enum.sum()
      end)
      |> List.to_tuple()

    f2 * f3
  end
end
