defmodule Adventofcode2018.Day04ReposeRecordP2 do
  use Adventofcode2018
  import Adventofcode2018.Day04ReposeRecordP1

  def id_min(shift) do
    shift.sleeps
    |> Stream.concat()
    |> Stream.map(&({shift.id, &1}))
  end

  def most_freq_minute(input) do
    state = input
    |> String.trim()
    |> String.split("\n")
    |> Enum.sort()
    |> Enum.map(&parse_input/1)
    |> Enum.reduce(%Adventofcode2018.ParseState{}, &aggr_input/2)

    shifts = [state.cur_shift | state.shifts]
    {{id, min}, _} = shifts 
    |> Stream.flat_map(&id_min/1)
    |> freq_map()
    |> Map.to_list()
    |> Enum.sort_by(fn {{_, m},v} -> {-v, m} end)
    |> hd
    
    id * min
  end
end
