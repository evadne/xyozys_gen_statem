defmodule TTT.GameRule do
  @winning_patterns [
    ~w(north_west west south_west)a,
    ~w(north centre south)a,
    ~w(north_east east south_east)a,
    ~w(north_west north north_east)a,
    ~w(west centre east)a,
    ~w(south_west south south_east)a,
    ~w(north_west centre south_east)a,
    ~w(north_east centre south_west)a
  ]
  
  def next_state(state, board) do
    case find_winner(board) do
      nil -> next_turn_state(state, board)
      :x -> :winner_x
      :o -> :winner_o
    end
  end

  def can_mark_value?(:turn_x, board, cell, :x), do: is_empty?(board, cell)
  def can_mark_value?(:turn_o, board, cell, :o), do: is_empty?(board, cell)
  def can_mark_value?(_, _, _, _), do: false

  defp is_empty?(board, cell) do
    case Map.fetch(board, cell) do
      {:ok, nil} -> true
      _ -> false
    end
  end

  defp find_winner(board) do
    reduce_fun = fn pattern, _ ->
      case Enum.map(pattern, &Map.get(board, &1)) do
        [x, x, x] when x in ~w(x o)a -> {:halt, x}
        _ -> {:cont, nil}
      end
    end

    Enum.reduce_while(@winning_patterns, nil, reduce_fun)
  end

  defp next_turn_state(state, board) do
    values = board |> Map.delete(:__struct__) |> Enum.map(fn {_, v} -> v end)

    if Enum.any?(values, &is_nil/1) do
      case state do
        :turn_x -> :turn_o
        :turn_o -> :turn_x
      end
    else
      :tie
    end
  end
end
