defmodule Adventofcode2018.Day05AlchemicalReductionP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day05AlchemicalReductionP1

  describe "react_pass/2" do
    test "no subst" do
      assert ~c(abc) = react_pass(~c(abc)) |> Enum.reverse
    end
    test "empty case" do
      assert ~c(abc) = react_pass([], ~c(abc))
    end
    test "remove single case" do
      assert ~c() = react_pass(~c(aA))
      assert ~c() = react_pass(~c(Aa))
      assert ~c(c) = react_pass(~c(caA))
      assert ~c(c) = react_pass(~c(Aac))
    end
    test "remove all cases" do
      assert ~c(C) = react_pass(~c(aAbBCaA))
    end
    test "leave nested cases" do
      assert ~c(aA) = react_pass(~c(abBA)) |> Enum.reverse
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

    test "should return correct length" do
      assert 3 = "abCaBaAbDdAbBaAcd" |> polymer_size()
      assert 3 = "abCaBAabDdAbBaAcd" |> polymer_size()
    end

    test_with_puzzle_input do
      assert 10496 = puzzle_input() |> polymer_size()
    end
  end
end
