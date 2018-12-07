defmodule Adventofcode2018.Day06ChronalCoordinatesP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day06ChronalCoordinatesP1

  describe "parse_line/1" do
    test "return when success" do
      assert {100, 200} = parse_line("100, 200")
    end
  end

  describe "id_freqs/2" do
    test "return frequency map when success" do
      assert %{a: 1, b: 1, c: 2} = id_freqs([
        {:a, 1},
        {:b, 1},
        {:c, 1},
        {:c, 1}
      ])
    end
  end

  describe "neighbours/3" do
    test "return all 4 neighbours" do
      assert [
        {{10, 11}, 99, 200},
        {{10, 9}, 99, 200},
        {{11, 10}, 99, 200},
        {{9, 10}, 99, 200}
      ] = neighbours({10,10}, 99, 200)
    end
  end

  describe "to_points/1" do
    test "return map when success" do
      assert %{
        {1,1} => {-1, not_visited},
        {1,2} => {-1, not_visited},
        {2,1} => {-1, not_visited},
        {2,2} => {-1, not_visited},
      } = to_points({1,1, 2,2})
    end
  end

  describe "bounding_box/1" do
    test "bounding box for 1 point" do
      assert {1,10,1,10} = bounding_box([{1,10}])
    end
    test "bounding box for 2 points" do
      assert {1,1,10,10} = bounding_box([{10,1}, {1,10}])
    end
    test "bounding box for N points" do
      assert {1,1,100,100} = bounding_box([{1,10}, {10,1}, {100,5}, {5, 100}])
    end
  end
  describe "ids_on_border/2" do
    test "return unique border elements" do
      assert [:a] = ids_on_border({0,0, 2,2}, %{
        {0,0} => {:a, 1},
        {0,1} => {:a, 1},
        {0,2} => {:a, 1},
        {1,0} => {:a, 1},
        {1,1} => {:b, 1},
        {1,2} => {:a, 1},
        {2,0} => {:a, 1},
        {2,1} => {:a, 1},
        {2,2} => {:a, 1},
      })
    end
    test "return all unique border elements" do
      assert [:a, :c] = ids_on_border({0,0, 2,2}, %{
        {0,0} => {:a, 1},
        {0,1} => {:c, 1},
        {0,2} => {:a, 1},
        {1,0} => {:a, 1},
        {1,1} => {:b, 1},
        {1,2} => {:a, 1},
        {2,0} => {:a, 1},
        {2,1} => {:a, 1},
        {2,2} => {:a, 1},
      })
    end
  end

  describe "largest_area/1" do
    test "sample input" do
      assert 17 = """
      1, 1
      1, 6
      8, 3
      3, 4
      5, 5
      8, 9
      """ |> largest_area()
    end
    
    test_with_puzzle_input do
      assert 1337 = puzzle_input() |> largest_area()
    end
  end
end
