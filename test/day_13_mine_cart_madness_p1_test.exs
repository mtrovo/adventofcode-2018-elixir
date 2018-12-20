defmodule Adventofcode2018.Day13MineCartMadnessP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day13MineCartMadnessP1

  def sample_input do
    """
    /->-\\
    |   |  /----\\
    | /-+--+-\\  |
    | | |  | v  |
    \\-+-/  \\-+--/
      \\------/
    """
  end

  describe "parse_char/3" do
    test "return empty when space char" do
      assert :empty = parse_char(" ")
    end

    test "return atom when not space char" do
      backslash = String.to_atom("\\")
      assert :- = parse_char("-")
      assert :+ = parse_char("+")
      assert :/ = parse_char("/")
      assert :| = parse_char("|")
      assert ^backslash = parse_char("\\")
    end

    test "return assumed direction" do
      assert :- = parse_char(">")
      assert :- = parse_char("<")
      assert :| = parse_char("v")
      assert :| = parse_char("^")
    end
  end

  describe "has_cart/1" do
    test "return true when cart" do
      assert true = has_cart(">")
      assert true = has_cart("<")
      assert true = has_cart("^")
      assert true = has_cart("v")
    end

    test "return false for normal track" do
      assert !has_cart("-")
      assert !has_cart("|")
      assert !has_cart("\\")
      assert !has_cart("/")
      assert !has_cart("+")
    end
  end

  describe "parse_input/1" do
    test "return correct input map" do
      assert %{
               track: %{
                 {0, 0} => :/,
                 {1, 0} => :-,
                 {2, 0} => :-,
                 {4, 2} => :+
               },
               carts: [
                 %{pos: {2, 0}, crashed: false, dir: :east, state: :L},
                 %{pos: {9, 3}, crashed: false, dir: :north, state: :L}
               ]
             } = sample_input() |> parse_input()
    end
  end

  describe "next_move/2" do
    test "return next move for straight line horizontal" do
      assert %{pos: {3, 0}, dir: :east, state: :L} =
               next_move(%{pos: {2, 0}, dir: :east, state: :L}, :-)

      assert %{pos: {1, 0}, dir: :west, state: :L} =
               next_move(%{pos: {2, 0}, dir: :west, state: :L}, :-)
    end

    test "return next move for straight line vertical" do
      assert %{pos: {0, 1}, dir: :south, state: :L} =
               next_move(%{pos: {0, 2}, dir: :south, state: :L}, :|)

      assert %{pos: {0, 3}, dir: :north, state: :L} =
               next_move(%{pos: {0, 2}, dir: :north, state: :L}, :|)
    end

    test "return next move for / curve" do
      assert %{pos: {1, 0}, dir: :east, state: :L} =
               next_move(%{pos: {0, 0}, dir: :south, state: :L}, :/)

      assert %{pos: {0, 1}, dir: :north, state: :L} =
               next_move(%{pos: {0, 0}, dir: :west, state: :L}, :/)

      assert %{pos: {4, 3}, dir: :south, state: :L} =
               next_move(%{pos: {4, 4}, dir: :east, state: :L}, :/)

      assert %{pos: {3, 4}, dir: :west, state: :L} =
               next_move(%{pos: {4, 4}, dir: :north, state: :L}, :/)
    end

    test "return next move for \\ curve" do
      bs = String.to_atom("\\")

      assert %{pos: {3, 0}, dir: :west, state: :L} =
               next_move(%{pos: {4, 0}, dir: :south, state: :L}, bs)

      assert %{pos: {4, 1}, dir: :north, state: :L} =
               next_move(%{pos: {4, 0}, dir: :east, state: :L}, bs)

      assert %{pos: {0, 3}, dir: :south, state: :L} =
               next_move(%{pos: {0, 4}, dir: :west, state: :L}, bs)

      assert %{pos: {1, 4}, dir: :east, state: :L} =
               next_move(%{pos: {0, 4}, dir: :north, state: :L}, bs)
    end

    test "return next move for crossing facing west" do
      assert %{pos: {4, 3}, dir: :north, state: :C} =
               next_move(%{pos: {4, 2}, dir: :west, state: :L}, :+)

      assert %{pos: {3, 2}, dir: :west, state: :R} =
               next_move(%{pos: {4, 2}, dir: :west, state: :C}, :+)

      assert %{pos: {4, 1}, dir: :south, state: :L} =
               next_move(%{pos: {4, 2}, dir: :west, state: :R}, :+)
    end

    test "return next move for crossing facing north" do
      assert %{pos: {5, 2}, dir: :east, state: :C} =
               next_move(%{pos: {4, 2}, dir: :north, state: :L}, :+)

      assert %{pos: {4, 3}, dir: :north, state: :R} =
               next_move(%{pos: {4, 2}, dir: :north, state: :C}, :+)

      assert %{pos: {3, 2}, dir: :west, state: :L} =
               next_move(%{pos: {4, 2}, dir: :north, state: :R}, :+)
    end
  end

  describe "tick_halt_on_collision/2" do
    test "update cart positions" do
      assert %{
               carts: [
                 %{crashed: false, dir: :east, pos: {3, 0}, state: :L},
                 %{crashed: false, dir: :north, pos: {9, 4}, state: :L}
               ]
             } =
               sample_input()
               |> parse_input
               |> do_tick(&tick_halt_on_collision/2)
    end
  end

  describe "first_collision/1" do
    test "sample input" do
      assert {7, 3} = sample_input() |> first_collision()
    end

    test_with_puzzle_input do
      assert {41, 17} = puzzle_input() |> first_collision()
    end
  end
end
