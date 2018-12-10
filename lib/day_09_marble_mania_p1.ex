defmodule Adventofcode2018.Day09MarbleManiaP1 do
  use Adventofcode2018

  @debug false

  defmodule Game do
    defstruct [:players, :last_marble]
  end

  def game(players, last_marble) do
    %Game{players: players, last_marble: last_marble}
  end

  @spec parse_input(binary()) :: Adventofcode2018.Day09MarbleManiaP1.Game.t()
  def parse_input(input) do
    re = ~r/(\d+) players; last marble is worth (\d+) points/

    [ps, pts] =
      case Regex.run(re, input) do
        nil -> raise("parse error " <> input)
        [_, ps, pts] -> [ps, pts] |> Enum.map(&String.to_integer/1)
      end

    %Game{players: ps, last_marble: pts}
  end

  def debug_board(p, board) do
    if @debug do
      board_str =
        LinkedList.to_list(board)
        |> Enum.join("  ")

      IO.puts("##{p}  #{board_str}")
    end
  end

  def play_marbles(players, available_marbles, board \\ LinkedList.new([0]), scores \\ %{})

  def play_marbles(_, [], _, scores) do
    scores
  end

  def play_marbles([p | players], [marble | marbles], board, scores)
      when rem(marble, 23) == 0 do
    {head, board} = LinkedList.move_ccw(board, 7) |> LinkedList.delete_head
    add_score = marble + head.val
    scores = scores |> Map.update(p, add_score, &(&1 + add_score))

    debug_board(p, board)
    play_marbles(players, marbles, board, scores)
  end

  def play_marbles([p | players], [marble | marbles], board, scores) do
    board =
      board
      |> LinkedList.move_cw(1)
      |> LinkedList.insert(marble)

    debug_board(p, board)
    play_marbles(players, marbles, board, scores)
  end

  @spec highest_score(binary()) :: no_return()
  def highest_score(input) do
    game = input |> parse_input

    play_marbles(
      1..game.players
      |> Stream.cycle()
      |> Enum.take(game.last_marble)
      |> Enum.to_list(),
      1..game.last_marble
      |> Enum.to_list()
    )
    |> Map.values()
    |> Enum.max()
  end
end
