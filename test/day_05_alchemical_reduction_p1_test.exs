defmodule Adventofcode2018.Day05AlchemicalReductionTest do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day05AlchemicalReduction

  describe "has_repeated/2" do
    test "base case: empty list" do
      assert :not_found = pos_repeated([])
    end
    test "base case: found" do
      assert 0 = pos_repeated(~c(abc), ?A, 1)
    end
    test "return right position" do
      assert 8 = pos_repeated(~c(abcabcabcC))
    end
  end

  describe "react/1" do
    test "simple subst" do
      assert ~c(abd) = react(~c(abCcd))
    end
    test "simple nested subst" do
      assert ~c(abd) = react(~c(abCaAcd))
    end
    test "complex nested subst" do
      assert ~c(abd) = react(~c(abCaBaAbDdAbBaAcd))
    end
  end

  describe "polymer_size/1" do
    test "should work on both char cases" do
      assert 0 = "Aa" |> polymer_size()
      assert 0 = "aA" |> polymer_size()
    end

    test_with_puzzle_input do
      assert 10496 = puzzle_input() |> polymer_size()
    end
  end
end
