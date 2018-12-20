defmodule Adventofcode2018.Day13MineCartMadnessP2 do
  use Adventofcode2018, trim: false
  import Adventofcode2018.Day13MineCartMadnessP1

  def remove_crashed({c, cart}, ac) do
    if !ac[cart.pos] do
      {:cont, ac}
    else
      newcart = next_move(cart, c)

      ac =
        if ac[newcart.pos] do
          ac
          |> Map.delete(cart.pos)
          |> Map.delete(newcart.pos)
        else
          ac
          |> Map.delete(cart.pos)
          |> Map.put(newcart.pos, newcart)
        end

      {:cont, ac}
    end
  end

  def state_when_only_one_cart(stream) do
    stream
    |> Stream.drop_while(fn %{carts: carts} ->
      carts
      |> IO.inspect(label: "Carts")
      |> length() > 1
    end)
    |> Enum.take(1)
    |> hd
  end

  def last_cart_pos(input) do
    game =
      input
      |> parse_input

    game.track
    |> IO.inspect(label: "weird track", limit: :infinity)

    %{carts: [cart]} =
      game
      |> tick_stream(&remove_crashed/2)
      |> state_when_only_one_cart

    cart_coord(cart)
  end
end
