defmodule TTT.GameStateMachineTest do
  use ExUnit.Case

  test "x wins via Game State Machine" do
    {:ok, pid} = TTT.GameStateMachine.start_link()
    {:ok, :turn_x} = TTT.GameStateMachine.get_state(pid)
    {:ok, :turn_o, _} = TTT.GameStateMachine.mark(pid, :north_west, :x)
    {:ok, :turn_x, _} = TTT.GameStateMachine.mark(pid, :north_east, :o)
    {:ok, :turn_o, _} = TTT.GameStateMachine.mark(pid, :west, :x)
    {:ok, :turn_x, _} = TTT.GameStateMachine.mark(pid, :east, :o)
    {:ok, :winner_x, _} = TTT.GameStateMachine.mark(pid, :south_west, :x)
  end
end
