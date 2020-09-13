defmodule TicTacTest do
  use ExUnit.Case
  doctest TicTac

  test "creates a square" do
    assert Square.new(1,3) == {:ok, %Square{col: 1, row: 3}}
  end

  test "creates a gameboard of empty squares" do
    assert Square.new_board() == %{
      %Square{col: 1, row: 1} => :empty,
      %Square{col: 1, row: 2} => :empty,
      %Square{col: 1, row: 3} => :empty,
      %Square{col: 2, row: 1} => :empty,
      %Square{col: 2, row: 2} => :empty,
      %Square{col: 2, row: 3} => :empty,
      %Square{col: 3, row: 1} => :empty,
      %Square{col: 3, row: 2} => :empty,
      %Square{col: 3, row: 3} => :empty
    }
  end
end
