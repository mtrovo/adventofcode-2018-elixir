defmodule Adventofcode2018.Day15BeverageBanditsP1 do
  use Adventofcode2018

  def parse_char(c) do
    case c do
      c when c in ~w(G E) -> {:open, %{type: c, health: 200}}
      "#" -> {:wall, nil}
      "." -> {:open, nil}
    end
  end

  def parse_input(input, opts) do
    lines =
      input
      |> String.split("\n", trim: true)

    for {line, y} <- lines |> Enum.with_index(),
        {c, x} <- line |> String.graphemes() |> Enum.with_index() do
      {{x, y}, c}
    end
    |> Enum.reduce(%{units: %{}, map: %{}}, fn {pos, c}, %{units: units, map: map} ->
      {type, unit} = parse_char(c)

      units =
        if unit do
          Map.put(units, pos, unit)
        else
          units
        end

      %{units: units, map: Map.put(map, pos, type), gameover: false, ap: opts.ap}
    end)
  end

  def adjacent({x, y}), do: [{x, y - 1}, {x - 1, y}, {x + 1, y}, {x, y + 1}]

  def do_dist_map(queue, units, map, dist_map \\ %{}) do
    case :queue.out(queue) do
      {:empty, _} ->
        dist_map

      {{:value, {pos, dist}}, queue} ->
        if map[pos] == :open and !units[pos] and !dist_map[pos] do
          queue =
            pos
            |> adjacent
            |> Enum.map(&{&1, dist + 1})
            |> Enum.reduce(queue, &:queue.in(&1, &2))

          do_dist_map(queue, units, map, Map.put(dist_map, pos, dist))
        else
          do_dist_map(queue, units, map, dist_map)
        end
    end
  end

  def path(pos, unit, units, map) do
    queue =
      units
      |> Enum.filter(fn {_, cur} -> cur.type != unit.type end)
      |> Enum.flat_map(&adjacent(elem(&1, 0)))
      |> Enum.map(&{&1, 1})
      |> :queue.from_list()

    do_dist_map(queue, Map.delete(units, pos), map)
  end

  def next_position(unit, pos, units, map) do
    dist_map = path(pos, unit, units, map)

    dist_map
    |> Map.get(pos)
    |> case do
      1 ->
        pos

      _ ->
        pos
        |> adjacent
        |> Enum.map(&{&1, dist_map[&1]})
        |> Enum.filter(&elem(&1, 1))
        |> Enum.sort_by(fn {{x, y}, score} -> {score, y, x} end)
        |> case do
          [] -> pos
          [{new_pos, _} | _] -> new_pos
        end
    end
  end

  def is_gameover(units) do
    units
    |> Map.values()
    |> Enum.group_by(& &1.type)
    |> Enum.count() == 1
  end

  def tick(%{gameover: true} = battle), do: battle

  def tick(%{units: units, map: map, ap: %{"G" => atk_g, "E" => atk_e} = ap} = battle) do
    {new_units, part_ended} =
      units
      |> Map.keys()
      |> Enum.sort_by(fn {x, y} -> {y, x} end)
      |> Enum.reduce({units, false}, fn
        pos, {ac, part_ended} ->
          part_ended = part_ended or is_gameover(ac)

          if ac[pos] == nil do
            {ac, part_ended}
          else
            unit = ac[pos]
            new_pos = next_position(unit, pos, ac, map)

            ac =
              ac
              |> Map.delete(pos)
              |> Map.put(new_pos, unit)

            new_pos
            |> adjacent
            |> Enum.map(&{&1, ac[&1]})
            |> Enum.filter(&elem(&1, 1))
            |> Enum.filter(fn {_, cur} -> cur.type != unit.type end)
            |> Enum.sort_by(fn {{x, y}, %{health: h}} -> {h, y, x} end)
            |> case do
              [] ->
                {ac, part_ended}

              [{pos, %{health: curh, type: type}} | _]
              when (type == "G" and curh < atk_g) or (type == "E" and curh < atk_e) ->
                {Map.delete(ac, pos), part_ended}

              [{pos, %{type: type}} | _] ->
                {Map.update!(ac, pos, fn cur ->
                   %{cur | health: cur.health - ap[type]}
                 end), part_ended}
            end
          end
      end)

    gameover =
      cond do
        part_ended -> :partial
        is_gameover(new_units) -> :full
        true -> false
      end

    %{battle | units: new_units, gameover: gameover}
  end

  def strboard(%{map: map, units: units}, dist \\ %{}) do
    hx = map |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    hy = map |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    0..hy
    |> Enum.map(fn y ->
      line =
        0..hx
        |> Enum.map(fn x ->
          case units[{x, y}] do
            %{type: t} ->
              t

            nil ->
              case map[{x, y}] do
                :wall -> "#"
                :open -> Map.get(dist, {x, y}, ".")
              end
          end
        end)
        |> Enum.join("")

      hps =
        units
        |> Enum.filter(fn {{_, cury}, _} -> cury == y end)
        |> Enum.sort_by(fn {{x, _}, _} -> x end)
        |> Enum.map(fn {_, u} -> "#{u.type}(#{u.health})" end)
        |> Enum.join("")

      "#{line}   #{hps}"
    end)
    |> Enum.join("\n")
  end

  def inspectb(battle, dist \\ %{}, opts \\ %{}) do
    if Map.get(opts, :debug) do
      IO.write([IO.ANSI.home(), IO.ANSI.clear()])

      strboard(battle, dist)
      |> IO.puts()

      :timer.sleep(100)
    end

    battle
  end

  def checksum_endgame(input, opts \\ %{ap: %{"G" => 3, "E" => 3}}) do
    {battle, turn} =
      input
      |> parse_input(opts)
      |> Stream.iterate(&tick/1)
      |> Stream.map(&inspectb(&1, %{}, opts))
      |> Stream.with_index()
      |> Stream.drop_while(&(!Map.get(elem(&1, 0), :gameover)))
      |> Enum.take(1)
      |> hd

    sumh =
      battle.units
      |> Map.values()
      |> Enum.map(& &1.health)
      |> Enum.sum()

    turn =
      case battle.gameover do
        :partial -> turn - 1
        :full -> turn
        _ -> raise("invalid state")
      end

    IO.inspect(battle.units, label: "UNITS")
    IO.inspect({turn, sumh}, label: "Turn&Sum")

    sumh * turn
  end
end
