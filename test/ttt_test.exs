defmodule TTTTest do
  use ExUnit.Case
  doctest TTT

  test "X Wins (API)" do
    game = TTT.new()
    "X’s Turn" = TTT.status(game)

    # X always goes first
    {:error, _} = TTT.turn(game, :north_west, "O")

    {:ok, ^game} = TTT.turn(game, :north_west, "X")
    "O’s Turn" = TTT.status(game)

    {:ok, ^game} = TTT.turn(game, :north_east, "O")
    "X’s Turn" = TTT.status(game)

    {:ok, ^game} = TTT.turn(game, :west, "X")
    "O’s Turn" = TTT.status(game)

    {:ok, ^game} = TTT.turn(game, :east, "O")
    "X’s Turn" = TTT.status(game)

    {:ok, ^game} = TTT.turn(game, :south_west, "X")
    "X Wins" = TTT.status(game)
  end

  test "X Wins" do
    game = run_game(~w(north_west north_east west east south_west)a)
    "X Wins" = TTT.status(game)
  end

  test "O Wins" do
    game = run_game(~w(north_west north_east west east south south_east)a)
    "O Wins" = TTT.status(game)
  end

  test "Tie" do
    game = run_game(~w(north north_east centre south east west south_east north_west south_west)a)
    "Tie" = TTT.status(game)
  end

  test "Out of Moves" do
    game = run_game(~w(north north_east centre south east west south_east north_west south_west)a)
    "Tie" = TTT.status(game)
    {:error, _} = TTT.turn(game, :east, "O")
  end

  defp run_game(cells) do
    player_stream = Stream.cycle(["X", "O"])
    game = TTT.new()

    Enum.each(Stream.zip(player_stream, cells), fn {player, cell} ->
      _ = TTT.turn(game, cell, player)
    end)

    game
  end
end
