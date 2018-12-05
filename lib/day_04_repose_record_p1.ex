defmodule Adventofcode2018.GuardShift do
  defstruct id: -1, sleeps: []
end

defmodule Adventofcode2018.ParseState do
  defstruct sleep_start: -1, shifts: [], 
  cur_shift: %Adventofcode2018.GuardShift{id: -1, sleeps: []}
end

defmodule Adventofcode2018.GuardBegins do
  defstruct [:id]
end

defmodule Adventofcode2018.GuardAsleep do
  defstruct [:min]
end

defmodule Adventofcode2018.GuardAwake do
  defstruct [:min]
end

defmodule Adventofcode2018.Day04ReposeRecordP1 do
  use Adventofcode2018
  import Adventofcode2018.ParseState
  import Adventofcode2018.GuardShift


  def input_type(cur) do
    cond do
      String.contains?(cur, "begins") -> :begins
      String.contains?(cur, "wakes") -> :wakes
      String.contains?(cur, "falls") -> :sleeps
      true -> raise("No type for input:" <> cur)
    end
  end

  def parse_begins(cur) do
    id = ~r/\d+:\d+\] Guard #(\d+) begins shift/
      |> Regex.run(cur) 
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
      |> hd
    %Adventofcode2018.GuardBegins{id: id}
  end

  def parse_wakes(cur) do
    min = ~r/\d+:(\d+)\] wakes up/
      |> Regex.run(cur)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
      |> hd
    %Adventofcode2018.GuardAwake{min: min}
  end

  def parse_sleeps(cur) do
    min = ~r/\d+:(\d+)\] falls asleep/
      |> Regex.run(cur)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)
      |> hd
    %Adventofcode2018.GuardAsleep{min: min}
  end

  def parse_input(cur) do
    case input_type(cur) do
      :begins -> parse_begins(cur)
      :wakes -> parse_wakes(cur)
      :sleeps -> parse_sleeps(cur)
      _ -> raise("invalid input " <> cur)
    end
  end

  def aggr_input(cur, state) do
    case cur do
      %Adventofcode2018.GuardBegins{id: id} ->
        %Adventofcode2018.ParseState{state | 
          cur_shift: %Adventofcode2018.GuardShift{id: id},
          shifts: [state.cur_shift | state.shifts]
        }
      %Adventofcode2018.GuardAwake{min: min} ->
        new_shift = %Adventofcode2018.GuardShift{state.cur_shift | 
          sleeps: [state.sleep_start..(min-1) | state.cur_shift.sleeps]
        }
        %Adventofcode2018.ParseState{state | cur_shift: new_shift}
      %Adventofcode2018.GuardAsleep{min: min} ->
        %Adventofcode2018.ParseState{state | sleep_start: min}
    end
  end

  def sum_minutes(shift) do
    {shift.id, shift.sleeps 
      |> Enum.map(fn i..e -> e-i end)
      |> Enum.sum()}
  end

  def freq_map(list) do
    list
    |> Enum.group_by(&(&1), fn _ -> 1 end)
    |> Map.to_list
    |> Map.new(fn ({k, vs}) -> 
      {k, length(vs)}
    end)
  end

  def guard_id_minute(input) do
    state = input
    |> String.trim()
    |> String.split("\n")
    |> Enum.sort()
    |> Enum.map(&parse_input/1)
    |> Enum.reduce(%Adventofcode2018.ParseState{}, &aggr_input/2)

    shifts = [state.cur_shift | state.shifts]
    {id, _} = shifts
    |> Enum.map(&sum_minutes/1)
    |> Enum.reduce(%{}, fn({id, ms}, ac) -> 
      ac = if ac[id] == nil do
        Map.put(ac, id, 0)
      else
        ac
      end
      Map.put(ac, id, ac[id]+ms)
    end)
    |> Enum.max_by(fn {_, v} -> v end)

    {minute, _} = shifts
    |> Enum.filter(&(&1.id == id))
    |> Enum.map(&(&1.sleeps))
    |> Stream.concat()
    |> Stream.flat_map(&Enum.to_list/1)
    |> freq_map
    |> Map.to_list
    |> Enum.max_by(fn {_, v} -> v end)

    id * minute
  end
end
