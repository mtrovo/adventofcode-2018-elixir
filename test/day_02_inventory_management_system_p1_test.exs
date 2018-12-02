defmodule Adventofcode2018.Day02InventoryManagementSystemP1Test do
  use Adventofcode2018.AdventCase
  import Adventofcode2018.Day02InventoryManagementSystemP1
  describe "checksum/1" do
    test "2x 2 + 3x 3" do
      assert 6 = "aa123 c1c2c3 s1s234 n1n2n3 m1m2m3" |> checksum()
    end
    test "2x 2 + 0x 3" do
      assert 0 = "aa123 123456 s1s234 123456 123456" |> checksum()
    end
    test "0x 2 + 3x 3" do
      assert 0 = "qwerty c1c2c3 v3b412 z1z2z3 x1x2x3" |> checksum()
    end
    test "2x 2 + 3x 3 + 1x +3" do
      assert 0 = "qwerty c1c2c3 v3b412 z1z2z3 x1x2x3 aaaavcx welkhsd sadflhj" |> checksum()
    end
    test_with_puzzle_input do
      assert 5952 = puzzle_input() |> checksum()
    end
  end
end
