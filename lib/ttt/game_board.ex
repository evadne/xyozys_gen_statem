defmodule TTT.GameBoard do
  @type cell ::
          :north_west
          | :north
          | :north_east
          | :west
          | :centre
          | :east
          | :south_west
          | :south
          | :south_east

  @type tile :: :x | :o | nil

  @type t :: %__MODULE__{
          north_west: tile,
          north: tile,
          north_east: tile,
          west: tile,
          centre: tile,
          east: tile,
          south_west: tile,
          south: tile,
          south_east: tile
        }

  defstruct north_west: nil,
            north: nil,
            north_east: nil,
            west: nil,
            centre: nil,
            east: nil,
            south_west: nil,
            south: nil,
            south_east: nil

  def draw(board) do
    matrix = [
      [:north_west, :north, :north_east],
      [:west, :centre, :east],
      [:south_west, :south, :south_east]
    ]

    get_value = fn
      :x -> " X "
      :o -> " O "
      _ -> " - "
    end

    Enum.join(
      for line <- matrix do
        Enum.map(line, fn key -> get_value.(Map.get(board, key)) end)
        |> Enum.join(" | ")
      end,
      "\n"
    )
  end
end
