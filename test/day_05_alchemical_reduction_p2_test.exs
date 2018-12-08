defmodule Adventofcode2018.Day05AlchemicalReductionP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day05AlchemicalReductionP2

  describe "remove_letter/2" do
    test "base case: empty" do
      assert [] = remove_letter([], ?a)
    end

    test "remove same case" do
      assert ~c(b) = remove_letter(~c(ab), ?a)
    end

    test "remove diff case" do
      assert ~c(b) = remove_letter(~c(Ab), ?a)
    end

    test "remove all letters" do
      assert ~c(b) = remove_letter(~c(aaaAAAbaaaAAA), ?a)
    end
  end

  describe "rm_unit_length/1" do
    test_with_puzzle_input do
      assert 1337 = puzzle_input() |> rm_unit_length()
    end
  end
end
