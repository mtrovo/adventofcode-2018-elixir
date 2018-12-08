defmodule Adventofcode2018.Day02InventoryManagementSystemP2 do
  use Adventofcode2018

  def combinations2([]) do
    []
  end

  def combinations2([_ | ts]) when ts == [] do
    []
  end

  def combinations2([h | ts]) do
    Enum.map(ts, &{h, &1}) ++ combinations2(ts)
  end

  def btoi(b) do
    if(b, do: 1, else: 0)
  end

  def distance_chars([], []) do
    0
  end

  def distance_chars([_ | _], []) do
    99
  end

  def distance_chars([], [_ | _]) do
    99
  end

  def distance_chars([ha | ta], [hb | tb]) do
    btoi(ha != hb) + distance_chars(ta, tb)
  end

  def copy_eq({[], []}) do
    ""
  end

  def copy_eq({[h | ta], [h | tb]}) do
    h <> copy_eq({ta, tb})
  end

  def copy_eq({[_ | ta], [_ | tb]}) do
    copy_eq({ta, tb})
  end

  def common_letters_correct_ids(input) do
    input
    |> String.split()
    |> combinations2
    |> Enum.map(fn {a, b} ->
      {String.graphemes(a), String.graphemes(b)}
    end)
    |> Enum.filter(fn {as, bs} ->
      distance_chars(as, bs) == 1
    end)
    |> Enum.map(&copy_eq/1)
    |> hd
  end
end
