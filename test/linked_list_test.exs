defmodule LinkedListTest do
  use ExUnit.Case
  import LinkedList

  describe "new/1" do
    test "empty list" do
      assert %LinkedList{data: %{}} = new()
    end

    test "single elem list" do
      node = node(0, 0, 0, "VAL")
      assert %LinkedList{data: %{0 => ^node}, head: 0, gen_id: 1} = new(["VAL"])
    end
  end

  describe "insert/2" do
    test "empty list" do
      node = node(0, 0, 0, "VAL")

      assert %LinkedList{data: %{0 => ^node}, head: 0, gen_id: 1} =
               new()
               |> insert("VAL")
    end

    test "insert after head on full list" do
      expected = %LinkedList{
        data: %{
          0 => node(0, 2, 1, "A"),
          1 => node(1, 0, 2, "B"),
          2 => node(2, 1, 0, "C")
        },
        gen_id: 3,
        head: 2,
        size: 3
      }

      list = new() |> insert("A") |> insert("B") |> insert("C")
      assert ^expected = list
    end
  end

  describe "move_cw/2" do
    test "move to right cursor" do
      list = new() |> insert("A") |> insert("B") |> insert("C")

      assert "C" = head_node(list).val
      assert "B" = list |> move_cw(2) |> head_node |> Map.get(:val)
    end

    test "move to itself" do
      list = new() |> insert("A") |> insert("B") |> insert("C")

      assert "C" = head_node(list).val
      assert "C" = list |> move_cw(3) |> head_node |> Map.get(:val)
    end

    test "can cycle more then one time" do
      list = new() |> insert("A") |> insert("B") |> insert("C")

      assert "C" = head_node(list).val
      assert "B" = list |> move_cw(11) |> head_node |> Map.get(:val)
    end
  end

  describe "move_ccw/2" do
    test "move to right cursor" do
      list = new() |> insert("A") |> insert("B") |> insert("C")

      assert "C" = head_node(list).val
      assert "A" = list |> move_ccw(2) |> head_node |> Map.get(:val)
    end

    test "move to itself" do
      list = new() |> insert("A") |> insert("B") |> insert("C")

      assert "C" = head_node(list).val
      assert "C" = list |> move_ccw(3) |> head_node |> Map.get(:val)
    end

    test "can cycle more then one time" do
      list = new() |> insert("A") |> insert("B") |> insert("C")

      assert "C" = head_node(list).val
      assert "A" = list |> move_ccw(11) |> head_node |> Map.get(:val)
    end
  end

  describe "delete_head/1" do
    test "delete node from list" do
      {head, list} =
        new()
        |> insert("A")
        |> insert("B")
        |> insert("C")
        |> insert("D")
        |> move_ccw(1)
        |> delete_head()

      node_c = node(2, 1, 3, "C")

      expected = %LinkedList{
        data: %{
          0 => node(0, 3, 1, "A"),
          1 => node(1, 0, 3, "B"),
          3 => node(3, 1, 0, "D")
        },
        gen_id: 4,
        head: 3,
        size: 3
      }

      assert ^expected = list
      assert ^node_c = head
    end
  end
end
