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
    player = game.current_player

    with {col, row} <- game.ui.(game, :request_move),
      {:ok, board}  <- play_at(game.board, col, row, game.current_player),
      {:ok, game}   <- State.event(%{game | board: board}, {:play, game.current_player}),
      won?          <- win_check(board, player),
      {:ok, game}   <- State.event(game, {:check_for_winner, won?}),
      is_over?      <- game_over(game),
      {:ok, game}   <- State.event(game, {:game_over?, is_over?}),
    do: handle(game), else: (error -> error)
  end

  def handle(%{status: :game_over} = game) do
    game.ui.(game, nil)
  end

  def handle(%{status: _} = game) do
    {:error, %{unknown_error: game}}
  end

  @doc """
  Check if player is valid
  """
  def check_player(player) do
    # IO.puts("check_player")
    # require IEx; IEx.pry

    case player do
      :x -> {:ok, player}
      :o -> {:ok, player}
      _ -> {:error, :dat_one}
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

  defp game_over(game) do
    board_full = Enum.all?(game.board, fn {_, v} -> v != :empty end)
    if board_full or game.winner do
      :game_over
    else
      :not_over
    end
  end

  defp win_check(board, player) do
    cols = Enum.map(1..3, &get_col(board, &1))
    rows = Enum.map(1..3, &get_row(board, &1))
    diags = get_diagonals(board)

    win? = Enum.any?(cols ++ rows ++ diags, &won_line(&1, player))
    if win?, do: player, else: false
  end

  defp won_line(line, player), do: Enum.all?(line, &(player == &1))

  defp get_col(board, col) do
    for {%{col: c, row: _}, v} <- board, col == c, do: v
  end

  defp get_row(board, row) do
    for {%{col: _, row: r}, v} <- board, row == r, do: v
  end

  defp get_diagonals(board) do
    [(for {%{col: c, row: r}, v} <- board, c == r, do: v),
    (for {%{col: c, row: r}, v} <- board, c + r == 4, do: v)]
  end

  def card_deck do
    values = Enum.to_list(2..10) ++ ["Jack", "Queen", "King", "Ace"]
    suits =  ["Hearts", "Spaces", "Clubs", "Diamonds"]

    for s <- suits, v <- values,  do: "#{v} of #{s}"
  end
end


