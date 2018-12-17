defmodule Adventofcode2018.Day12SubterraneanSustainabilityP1 do
  use Adventofcode2018
  use Bitwise

  @inmap %{"#" => 1, "." => 0}
  @outmap %{1 => "#", 0 => "."}
  @lpad [0, 0, 0, 0, 0]
  @rpad [0, 0, 0, 0]

  @debug true

  def bin_list(strbins) do
    strbins
    |> String.graphemes()
    |> Enum.map(&Map.get(@inmap, &1))
  end

  def parse_initial(initial) do
    [_, str_state] =
      initial
      |> String.split(": ")

    data =
      str_state
      |> bin_list

    %{start: 0, data: data, curgen: 0}
  end

  def parse_rule(line) do
    [bins, v] =
      line
      |> String.trim()
      |> String.split(" => ")

    {bins |> bin_list |> Integer.undigits(2), @inmap[v]}
  end

  def parse_input(input) do
    [initial | tail] =
      input
      |> String.split("\n", trim: true)

    state = parse_initial(initial)

    rules =
      tail
      |> Enum.map(&parse_rule/1)
      |> Enum.into(%{})

    %{state: state, rules: rules, stable: false}
  end

  def has_plant({v, _}) do
    v == 1
  end

  defp do_update_generation(hdata, ldata, rules, cursum \\ 0, out \\ [])

  defp do_update_generation(_, [], _, _, out) do
    data = out |> Enum.reverse()
    %{data: data}
  end

  defp do_update_generation([h | htail], [lh | ltail], rules, cursum, out) do
    sub = 16 * h
    newsum = ((cursum - sub) <<< 1) + lh
    out = [Map.get(rules, newsum, 0) | out]

    do_update_generation(htail, ltail, rules, newsum, out)
  end

  def trim_state(state) do
    [data, [start | _]] =
      state.data
      |> Stream.with_index(state.start)
      |> Stream.drop_while(&(elem(&1, 0) == 0))
      |> Enum.reverse()
      |> Stream.drop_while(&(elem(&1, 0) == 0))
      |> Enum.reverse()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    %{state | start: start, data: data}
  end

  def update_generation(next) do
    do_update_generation(
      @lpad ++ next.state.data,
      next.state.data ++ @rpad,
      next.rules
    )
    |> Map.put(:curgen, next.state.curgen + 1)
    |> Map.put(:start, next.state.start - 2)
  end

  def generation_stream(input) do
    if @debug do
      input.state
      |> debug_generation()
    end

    Stream.unfold(input, fn
      %{stable: true} = input ->
        {input, input}

      next ->
        state = update_generation(next)

        {state, stable} =
          if rem(state.curgen, 1) == 0 do
            next_state =
              state
              |> trim_state
              |> debug_generation()

            stable = next_state.data == (next.state |> trim_state).data

            {next_state, stable}
          else
            {state, false}
          end

        {next, %{next | state: state, stable: stable}}
    end)
  end

  def fetch_stable_generation(stream, gen) do
    stream
    |> Stream.drop_while(fn input ->
      input.state.curgen < gen && !input.stable
    end)
    |> Enum.take(1)
    |> hd
  end

  def fetch_generation(stream, gen) do
    stream
    |> Stream.drop(gen)
    |> Enum.take(1)
    |> hd
  end

  def debug_generation(state) do
    pad = String.pad_trailing(state.start |> to_string, 9 + min(0, state.start), ".")

    content =
      state.data
      |> Enum.map(&@outmap[&1])
      |> Enum.join("")

    IO.puts(
      (pad <> content)
      |> String.pad_trailing(40, ".")
    )

    state
  end

  def sum_index_with_plant(state) do
    state.data
    |> Enum.with_index(state.start)
    |> Enum.filter(&has_plant/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def sum_pots(input, num_generations) do
    %{state: state} =
      input
      |> parse_input
      |> generation_stream
      |> fetch_generation(num_generations)

    state
    |> sum_index_with_plant()
  end
end
