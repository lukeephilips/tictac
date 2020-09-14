defmodule TicTac do

  @moduledoc """
  Documentation for TicTacToe game.
  """

  alias TicTac.{Square, State}

  def start(ui) do
    with {:ok, game} <- State.new(ui),
         player         <- ui.(game, :get_player),
         {:ok, game}    <- State.event(game, {:choose_p1, player}),
    do: handle(game), else: (error -> error)
  end

  def handle(%{status: :in_progress} = game) do
    with {col, row} <- game.ui.(game, :request_move),
      {:ok, board} <- play_at(game.board, col, row, game.current_player),
      {:ok, game} <- State.event(%{game | board: board}, {:play, game.current_player}),
    do: handle(game), else: (error -> error)
  end

  def handle(%{status: _} = game) do
    {:error, game}
  end

  @doc """
  Check if player is valid
  """
  def check_player(player) do
    case player do
      :x -> {:ok, player}
      :o -> {:ok, player}
      _ -> {:error, :invalid_player}
    end
  end

  @doc """
  Calls `place_piece` at `col`, `row` for `player` on `board
  """
  def play_at(board, col, row, player) do
    with {:ok, valid_player}  <- check_player(player),
         {:ok, square}        <- Square.new(col, row),
         {:ok, updated_board}     <- place_piece(board, square, valid_player),
    do: {:ok, updated_board}, else: (error -> error)
  end

    defp place_piece(board, place, player) do
    case board[place] do
      nil -> {:error, :invalid_location}
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


