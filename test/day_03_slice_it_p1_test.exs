defmodule Adventofcode2018.Day03SliceItP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day03SliceItP1

  describe "cross_prod/2" do
    test "return cross product list" do 
      assert [{1, 2}, {1, 3}, {2, 2}, {2, 3}] = 
        cross_prod([1,2], [2,3]) |> Enum.to_list
    end
  end
  describe "parse_input/1" do
    test "return rect when correct" do
      assert %Adventofcode2018.Rect{
        pos: %Adventofcode2018.Point2D{x: 749, y: 666},
        size: %Adventofcode2018.Point2D{x: 27, y: 15}
      } = "#1 @ 749,666: 27x15"
        |> parse_input
    end
  end
  describe "square_points/1" do
    test "return stream with correct points" do
      # 1,1: 3x3
      assert [
        {1,1}, {1,2}, {1,3},
        {2,1}, {2,2}, {2,3},
        {3,1}, {3,2}, {3,3}
      ] = square_points(create_rect(999, 1,1, 3,3))
      |> Enum.to_list
    end
  end
  describe "common_squares/1" do
    test "single rect; no overlaps" do
      assert 0 = "#1 @ 749,666: 27x15" |> common_squares()
    end
    test "two rects; 1 sq overlapping" do
      assert 1 = 
      """
      #1 @ 1,1: 3x3
      #2 @ 3,3: 2x2
      """ 
      |> String.trim()
      |> common_squares()
    end

    @tag timeout: 1_100_100
    test_with_puzzle_input do
      assert 104241 = puzzle_input() |> common_squares()
    end
  end
end
