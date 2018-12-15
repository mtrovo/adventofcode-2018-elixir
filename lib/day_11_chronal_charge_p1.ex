defmodule Adventofcode2018.Day11ChronalChargeP1 do
  use Adventofcode2018

  def parse_input(input) do
    input |> String.to_integer()
  end

  def fuel_level({x, y}, sn) do
    rack_id = x + 10
    level = rack_id * y
    level = level + sn
    level = level * rack_id
    div(rem(level, 1000), 100) - 5
  end

  def new_grid(sn, size \\ 300) do
    1..size
    |> Enum.to_list()
    |> Enum.map(fn y ->
      1..size
      |> Enum.to_list()
      |> Enum.map(&fuel_level({&1, y}, sn))
    end)
  end

  def all_sums_on_line(_, [], _, sums) do
    sums
  end

  def all_sums_on_line([i | inic], [e | endc], cursum, sums) do
    cursum = cursum + e - i
    all_sums_on_line(inic, endc, cursum, [cursum | sums])
  end

  def calc_sums_line(line, size) do
    cursum =
      line
      |> Enum.take(size)
      |> Enum.sum()

    all_sums_on_line(line, line |> Enum.drop(size), cursum, [cursum])
    |> Enum.reverse()
  end

  def calc_sum_square(grid, size) do
    grid
    |> Enum.map(&calc_sums_line(&1, size))
    |> Enum.zip()
    |> Enum.map(&calc_sums_line(Tuple.to_list(&1), size))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def debug_grid(grid) do
    grid
    |> Enum.map(fn line ->
      line
      |> Enum.map(fn cell ->
        case cell do
          nil -> "E"
          val when val > 0 -> "+#{val}"
          0 -> " 0"
          val -> to_string(val)
        end
      end)
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    grid
  end

  def max_sum_coord(sums) do
    sums
    |> Enum.with_index(1)
    |> Enum.map(fn {line, y} ->
      {v, x} =
        line
        |> Enum.with_index(1)
        |> Enum.max_by(&elem(&1, 0))

      {x, y, v}
    end)
    |> Enum.max_by(&elem(&1, 2))
  end

  def max_3x3_coord(input) do
    sums =
      input
      |> parse_input
      |> new_grid
      |> calc_sum_square(3)

    {x, y, _} =
      sums
      |> max_sum_coord

    {x, y}
  end
end
