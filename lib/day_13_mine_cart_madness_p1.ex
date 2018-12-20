defmodule Adventofcode2018.Day13MineCartMadnessP1 do
  use Adventofcode2018

  @bs String.to_atom("\\")
  @cartchars MapSet.new(String.graphemes("><^v"))
  @rotation %{
    east: %{L: :south, R: :north, C: :east},
    west: %{L: :north, R: :south, C: :west},
    north: %{L: :east, R: :west, C: :north},
    south: %{L: :west, R: :east, C: :south}
  }

  @spec parse_char(any()) :: any()
  def parse_char(c) do
    case c do
      " " -> :empty
      ">" -> :-
      "<" -> :-
      "v" -> :|
      "^" -> :|
      a -> String.to_atom(a)
    end
  end

  def parse_line(line, y) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {c, x} ->
      {{x, y}, parse_char(c)}
    end)
  end

  @spec has_cart(String.t()) :: boolean()
  def has_cart(c) do
    MapSet.member?(@cartchars, c)
  end

  def parse_carts(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(&has_cart(elem(&1, 0)))
      |> Enum.map(fn {c, x} ->
        base = %{pos: {x, y}, dir: nil, crashed: false, state: :L}

        case c do
          "v" -> %{base | dir: :north}
          "^" -> %{base | dir: :south}
          ">" -> %{base | dir: :east}
          "<" -> %{base | dir: :west}
          _ -> raise("invalid state at " <> inspect({x, y}))
        end
      end)
    end)
  end

  def parse_input(input) do
    track =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        parse_line(line, y)
      end)
      |> Enum.into(%{})

    carts = parse_carts(input)
    %{track: track, carts: carts}
  end

  def to_pos_map(carts) do
    carts
    |> Enum.map(fn cart ->
      {cart.pos, cart}
    end)
    |> Enum.into(%{})
  end

  def update_pos({x, y}, dir) do
    case dir do
      :south -> {x, y - 1}
      :north -> {x, y + 1}
      :east -> {x + 1, y}
      :west -> {x - 1, y}
    end
  end

  def bif_next_dir_state(cart) do
    dir = @rotation[cart.dir][cart.state]

    state =
      case cart.state do
        :L -> :C
        :C -> :R
        :R -> :L
      end

    {dir, state}
  end

  def next_move(cart, c) do
    bs = @bs

    {dir, state} =
      case c do
        :+ ->
          bif_next_dir_state(cart)

        :/ ->
          case cart.dir do
            :north -> {:west, cart.state}
            :south -> {:east, cart.state}
            :east -> {:south, cart.state}
            :west -> {:north, cart.state}
          end

        ^bs ->
          case cart.dir do
            :north -> {:east, cart.state}
            :south -> {:west, cart.state}
            :west -> {:south, cart.state}
            :east -> {:north, cart.state}
          end

        nil ->
          raise("cart out of track " <> inspect(cart))

        :empty ->
          raise("cart out of track " <> inspect(cart))

        _ ->
          {cart.dir, cart.state}
      end

    pos = update_pos(cart.pos, dir)
    %{cart | pos: pos, dir: dir, state: state}
  end

  @spec do_tick(
          %{carts: List.t(), track: Map.t()},
          ({any(), Atom.t()}, any() -> {:cont, any()} | {:halt, any()})
        ) :: %{carts: [any()], track: any()}
  def do_tick(game, reducer) do
    carts = to_pos_map(game.carts)

    carts =
      game.carts
      |> Enum.map(&Map.get(game.track, &1.pos))
      |> Enum.zip(game.carts)
      |> Enum.reduce_while(carts, reducer)
      |> Map.values()

    %{game | carts: carts}
  end

  def tick_halt_on_collision({c, cart}, ac) do
    newcart = next_move(cart, c)

    {action, newcart} =
      if ac[newcart.pos] do
        {:halt, %{newcart | crashed: true}}
      else
        {:cont, newcart}
      end

    ac =
      ac
      |> Map.delete(cart.pos)
      |> Map.put(newcart.pos, newcart)

    {action, ac}
  end

  def tick_stream(game, reducer) do
    Stream.iterate(game, &do_tick(&1, reducer))
  end

  def has_collided(%{carts: carts}) do
    crashed_cart(carts) != nil
  end

  def find_first_collision(stream) do
    stream
    |> Stream.drop_while(&(!has_collided(&1)))
    |> Enum.take(1)
    |> hd
  end

  def crashed_cart(carts) do
    carts
    |> Enum.find(&(Map.get(&1, :crashed) == true))
  end

  def cart_coord(%{pos: pos}) do
    pos
  end

  def first_collision(input) do
    game =
      input
      |> parse_input
      |> tick_stream(&tick_halt_on_collision/2)
      |> find_first_collision

    game.carts
    |> crashed_cart
    |> cart_coord
  end
end
