defmodule TicTac do

  @moduledoc """
  Documentation for TicTac.
  """

  alias TicTac.Square

  @doc """
  Calls `place_piece` at `col`, `row` for `player` on `board
  """
  def play_at(board, col, row, player) do
    with {:ok, valid_player}  <- check_player(player),
         {:ok, square}        <- Square.new(col, row),
         {:ok, updated_board}     <- place_piece(board, square, valid_player),
    do: updated_board
  end

  def check_player(player) do
    case player do
      :x -> {:ok, player}
      :o -> {:ok, player}
      _ -> {:error, :invalid_player}
    end
  end

  defp place_piece(board, place, player) do
    case board[place] do
      nil -> {:error, :invalid_place}
      :x -> {:error, :occupied}
      :o -> {:error, :occupied}
      :empty -> {:ok, %{board | place => player}}
    end
  end

  def card_deck do
    values = Enum.to_list(2..10) ++ ["Jack", "Queen", "King", "Ace"]
    suits =  ["Hearts", "Spaces", "Clubs", "Diamonds"]

    for s <- suits, v <- values,  do: "#{v} of #{s}"
  end
end


