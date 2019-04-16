defmodule TTT do
  alias TTT.GameStateMachine
  alias TTT.GameBoard

  @typep game :: pid()
  @spec new() :: game
  @spec turn(game, GameBoard.cell(), String.t()) :: {:ok, game} | {:error, term()}
  @spec status(game) :: String.t()

  def new do
    {:ok, pid} = GameStateMachine.start_link()
    pid
  end

  def turn(pid, cell, "X"), do: mark(pid, cell, :x)
  def turn(pid, cell, "O"), do: mark(pid, cell, :o)

  def status(pid) do
    pid
    |> GameStateMachine.get_state()
    |> translate_state()
  end

  defp mark(pid, cell, value) do
    case GameStateMachine.mark(pid, cell, value) do
      {:ok, _, _} -> {:ok, pid}
      {:error, reason} -> {:error, reason}
    end
  end

  defp translate_state({:ok, :turn_x}), do: "X’s Turn"
  defp translate_state({:ok, :turn_o}), do: "O’s Turn"
  defp translate_state({:ok, :winner_x}), do: "X Wins"
  defp translate_state({:ok, :winner_o}), do: "O Wins"
  defp translate_state({:ok, :tie}), do: "Tie"
end
