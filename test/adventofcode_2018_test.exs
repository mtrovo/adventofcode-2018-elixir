defmodule Adventofcode2018Test do
  use ExUnit.Case
  import Adventofcode2018

  describe "freq_map/1" do
    test "return frequency map on success" do
      assert %{a: 1, c: 2, e: 3} = freq_map([:a, :e, :e, :c, :e, :c])
    end
  end

  describe "cross_prod/2" do
    test "return cross product list" do
      assert [{1, 2}, {1, 3}, {2, 2}, {2, 3}] = cross_prod([1, 2], [2, 3]) |> Enum.to_list()
    end
  end

  describe "bounding_box/1" do
    test "bounding box for 1 point" do
      assert {1, 10, 1, 10} = bounding_box([{1, 10}])
    end

    test "bounding box for 2 points" do
      assert {1, 1, 10, 10} = bounding_box([{10, 1}, {1, 10}])
    end

    test "bounding box for N points" do
      assert {1, 1, 100, 100} = bounding_box([{1, 10}, {10, 1}, {100, 5}, {5, 100}])
    end
  end
end
