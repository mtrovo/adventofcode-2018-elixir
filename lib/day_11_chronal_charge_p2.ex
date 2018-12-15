defmodule Adventofcode2018.Day11ChronalChargeP2 do
  use Adventofcode2018
  import Adventofcode2018.Day11ChronalChargeP1

  def max_sum_square(input) do
    grid = input |> parse_input |> new_grid

    3..300
    |> Enum.map(fn size ->
      {x, y, v} =
        grid
        |> calc_sum_square(size)
        |> max_sum_coord

      {{x, y, size}, v}
    end)
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
  end
end
