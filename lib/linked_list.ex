# Circular Double Linked List
defmodule LinkedList do
  defstruct data: %{}, head: nil, gen_id: 0, size: 0

  defmodule Node do
    defstruct [:id, :prev, :next, :val]
  end

  def node(id, prev, next, val) do
    %Node{id: id, prev: prev, next: next, val: val}
  end

  def new(list \\ []) do
    Enum.reduce(list, %LinkedList{}, &insert(&2, &1))
  end

  def node_at(list, id) do
    list.data[id]
  end

  def next_node(list) do
    next = node_at(list, list.head).next
    node_at(list, next)
  end

  def insert(%LinkedList{data: data, gen_id: id}, item) when data == %{} do
    %LinkedList{data: %{id => node(id, id, id, item)}, head: id, gen_id: id + 1, size: 1}
  end

  def insert(%LinkedList{gen_id: id, head: h, size: size} = list, item) when size == 1 do
    cur = %Node{node_at(list, h) | prev: id, next: id}

    %LinkedList{
      data: %{
        id => node(id, cur.id, cur.id, item),
        cur.id => cur
      },
      head: id,
      gen_id: id + 1,
      size: 2
    }
  end

  def insert(list, item) do
    id = list.gen_id
    next = next_node(list)
    cur = node_at(list, list.head)
    new_node = node(id, next.prev, next.id, item)
    cur = %{cur | next: new_node.id}
    next = %{next | prev: new_node.id}

    data =
      list.data
      |> Map.put(id, new_node)
      |> Map.put(cur.id, cur)
      |> Map.put(next.id, next)

    %LinkedList{data: data, gen_id: id + 1, head: id, size: list.size + 1}
  end

  def delete_head(list) do
    %Node{next: next_id, prev: prev_id} = head = head_node(list)
    next = %Node{node_at(list, next_id) | prev: prev_id}
    prev = %Node{node_at(list, prev_id) | next: next_id}

    {head,
     %LinkedList{
       list
       | data: %{list.data | next_id => next, prev_id => prev} |> Map.delete(list.head),
         head: next_id,
         size: list.size - 1
     }}
  end

  def move_cw(list, steps) do
    current =
      1..steps
      |> Enum.reduce(list.head, fn _, ac ->
        node_at(list, ac).next
      end)

    %LinkedList{list | head: current}
  end

  def move_ccw(list, steps) do
    current =
      1..steps
      |> Enum.reduce(list.head, fn _, ac ->
        list.data[ac].prev
      end)

    %LinkedList{list | head: current}
  end

  def head_node(list) do
    node_at(list, list.head)
  end

  def to_list(list) do
    min = list.data |> Map.keys() |> Enum.min()

    1..list.size
    |> Enum.reduce({[], min}, fn v, {ret, curid} ->
      cur = node_at(list, curid)

      val =
        if curid == list.head do
          "(#{cur.val})"
        else
          to_string(cur.val)
        end

      ret = [val | ret]
      {ret, cur.next}
    end)
    |> elem(0)
    |> Enum.reverse()
  end
end
