defmodule TTT.GameStateMachine do
  alias TTT.GameBoard
  alias TTT.GameRule
  require Logger

  @behaviour :gen_statem
  @type state :: :turn_x | :turn_o | :tie | :winner_x | :winner_o
  @type data :: GameBoard.t()
  @mark_states ~w(turn_x turn_o)a

  def start_link(game \\ %GameBoard{}) do
    :gen_statem.start_link(__MODULE__, [game], [])
  end

  def mark(pid, cell, value) do
    :gen_statem.call(pid, {:mark, cell, value})
  end

  def get_state(pid) do
    :gen_statem.call(pid, :get_state)
  end

  def callback_mode do
    :handle_event_function
  end

  def init([%GameBoard{} = game_board]) do
    Logger.info("New Game")
    {:ok, :turn_x, game_board}
  end

  def handle_event({:call, from}, {:mark, _, _}, state, _) when state not in @mark_states do
    {:keep_state_and_data, {:reply, from, {:error, :game_over}}}
  end

  def handle_event({:call, from}, {:mark, _, :x}, :turn_o, _) do
    {:keep_state_and_data, {:reply, from, {:error, :wrong_turn}}}
  end

  def handle_event({:call, from}, {:mark, _, :o}, :turn_x, _) do
    {:keep_state_and_data, {:reply, from, {:error, :wrong_turn}}}
  end

  def handle_event({:call, from}, {:mark, cell, value}, state, data) do
    handle_mark(from, cell, value, state, data)
  end

  def handle_event({:call, from}, :get_state, state, _data) do
    {:keep_state_and_data, {:reply, from, {:ok, state}}}
  end

  defp handle_mark(from, cell, value, state, data) do
    if GameRule.can_mark_value?(state, data, cell, value) do
      to_data = Map.put(data, cell, value)
      to_state = GameRule.next_state(state, to_data)
      log_mark(cell, value, state, to_state, to_data)
      {:next_state, to_state, to_data, [{:reply, from, {:ok, to_state, to_data}}]}
    else
      {:keep_state_and_data, {:reply, from, {:error, :invalid_move}}}
    end
  end
  
  defp log_mark(cell, value, state, to_state, to_data) do
    Logger.info(fn ->
      ["Turn #{state} - #{cell} #{value} -> #{to_state}", "\n", GameBoard.draw(to_data)]
    end)
  end
end
