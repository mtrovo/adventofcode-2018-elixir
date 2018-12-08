defmodule Adventofcode2018.Day02InventoryManagementSystemP2Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day02InventoryManagementSystemP2

  describe "common_letters_correct_ids/1" do
    test "find common suffix" do
      assert "bc" = "aaa abc bbc" |> common_letters_correct_ids()
    end

    test "find common prefix" do
      assert "aa" = "aaa aab bbc" |> common_letters_correct_ids()
    end

    test_with_puzzle_input do
      assert "krdmtuqjgwfoevnaboxglzjph" = puzzle_input() |> common_letters_correct_ids()
    end
  end
end
