defmodule Square do
  @moduledoc """
  It's a freakin square builder
  """
  @enforce_keys [:col, :row]

  defstruct [:col, :row]

  def new(col, row) when col in 1..3 and row in 1..3 do
    {:ok, %Square{row: row,  col: col}}
  end

  def new(_col, _row), do: {:error, :invalid_square}
end