defmodule Adventofcode2018.Day10TheStarsAlignP2 do
  use Adventofcode2018
  import Adventofcode2018.Day10TheStarsAlignP1
  def wait_in_seconds(input) do
    input |> parse_input
    |> play_stream
    |> Stream.take_while(&(not sky_aligned(&1)))
    |> Stream.map(fn _ -> 1 end)
    |> Enum.sum
  end
end
