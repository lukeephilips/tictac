defmodule TicTac.Square do
  @moduledoc """
  It's a freakin square builder
  """
  @enforce_keys [:col, :row]
  defstruct [:col, :row]

  alias TicTac.Square

  @board_size 1..3

  @doc """
  Returns a Square on the given point.
  """
  def new(col, row) when col in @board_size and row in @board_size do
    {:ok, %Square{row: row,  col: col}}
  end


  def new(_col, _row), do: {:error, :invalid_square}

  @doc """
  Creates a new_board of :empty Squares
  """
  def new_board do
    for s <- squares(), into: %{}, do: {s, :empty}
  end

  @doc """
  Creates MapSet of Squares for the game board
  """
  defp squares do
    for c <- @board_size, r <- @board_size, into: MapSet.new(), do: %Square{col: c, row: r}
  end
end