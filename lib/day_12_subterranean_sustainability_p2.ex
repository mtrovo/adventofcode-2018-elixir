defmodule Adventofcode2018.Day12SubterraneanSustainabilityP2 do
  use Adventofcode2018
  import Adventofcode2018.Day12SubterraneanSustainabilityP1

  @desired_gen 50_000_000_000
  @spec sum_1500y(binary()) :: number()
  def sum_1500y(input) do
    game =
      input
      |> parse_input
      |> generation_stream
      |> fetch_stable_generation(@desired_gen)

    next_state =
      game
      |> update_generation()
      |> trim_state()

    dgen = @desired_gen - game.state.curgen
    dix = next_state.start - game.state.start

    final_state = %{game.state | start: game.state.start + dgen * dix, curgen: @desired_gen}

    sum_index_with_plant(final_state)
  end
end
