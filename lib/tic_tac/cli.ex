defmodule TicTac.CLI do
  alias TicTac.{State, CLI}

  def play() do
    TicTac.start(&CLI.handle/2)
  end

  def handle(%State{status: :initial}, :get_player) do
    IO.gets("Who's going first, x or o? ")
    |> String.trim
    |> String.to_atom
  end

  def handle(%State{status: :in_progress} = state, :request_move) do
    display_board(state.board)
    IO.puts("What's your move, #{state.current_player}?")
    col = IO.gets("Col: ") |> trimmed_int
    row = IO.gets("Row: ") |> trimmed_int
    {col, row}
  end

  def handle(%State{status: :game_over} = state, _) do
    display_board(state.board)
    IO.puts("#{state.winner} won. Hooray.")
  end

  def show(board, c, r) do
    [item] = for {%{col: col, row: row}, v} <- board,
             col == c, row == r, do: v
    if item == :empty, do: " ", else: to_string(item)
  end

  def display_board(b) do
    IO.puts """
    #{show(b,1,1)} | #{show(b,2,1)} | #{show(b,3,1)}
    ----------
    #{show(b,1,2)} | #{show(b,2,2)} | #{show(b,3,2)}
    ----------
    #{show(b,1,3)} | #{show(b,2,3)} | #{show(b,3,3)}
    """
  end

  defp trimmed_int(str) do
    str |> String.trim |> String.to_integer
    # case Integer.parse(str) do
    #   {:ok, int} -> int
    #   error         -> error
    # end
  end
end