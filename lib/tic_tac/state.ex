defmodule TicTac.State do

  alias TicTac.{Square, State}
  @players [:x, :o]

  # statuses: initial, choose_p1, in_progress, game_over, winner_declared
  # events :choose_p1, current_player
  defstruct status: :initial,
            current_player: nil,
            winner: nil,
            board: Square.new_board(),
            ui: nil

  def new(), do: {:ok, %State{}}
  def new(ui), do: {:ok, %State{ui: ui}}

  # Initial state -> choose player 1
  def event(%State{status: :initial} = state, {:choose_p1, player }) do
    case TicTac.check_player(player) do
      {:ok, player} -> {:ok, %State{state | status: :in_progress, current_player: player}}
      _             -> {:error, :invalid_player}
    end
  end

  # Initial state -> other actions error
  def event(%State{status: :initial}, _action) do
    {:error, :players_not_yet_selected}
  end

  # other state -> tries to choose players error
  def event(%State{status: _status}, {:choose_p1, _player }) do
    {:error, :players_already_selected}
  end

  # player not in @players error
  def event(_state, {_, player}) when player not in @players do
    {:error, :invalid_player}
  end

  # play a turn
  def event(%State{status: :in_progress, current_player: current_player} = state, {:play, current_player}) do
    {:ok, %State{state | current_player: change_player(current_player)}}
  end

  # wrong player tries to play error
  def event(%State{status: :in_progress}, {:play, _}) do
    {:error, :out_of_turn}
  end

  # invalid player tries to play
  def event(%State{status: :in_progress} = state, {:check_for_winner, player}) do
    case player do
      :x -> {:ok, %State{state | status: :game_over, winner: player}}
      :o -> {:ok, %State{state | status: :game_over, winner: player}}
      _  -> {:error, :invalid_player}
    end
  end

  # check if game over
  def event(%State{status: :in_progress} = state, {:game_over?, over_or_not}) do
    case over_or_not do
      :not_over  -> {:ok, state}
      :game_over -> {:ok, %State{state | status: :game_over, winner: :none}}
      _          -> {:error, :invalid_game_over_status}
    end
  end

  # catch-all error
  def event(_state, action) do
    {:error, {:invalid_state_transtion, %{action: action}}}
  end

  defp change_player(current_player) do
    case current_player do
      :x -> :o
      :o -> :x
      _ -> {:error, :invalid_player}
    end
  end
end