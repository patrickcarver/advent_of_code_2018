defmodule Day09Alt do
  def run(num_players, limit) do
    state = %{
      num_players: num_players,
      current_marble: 1,
      limit: limit,
      marbles: %{0 => 0}
    }

    play_turn(state)
  end

  def play_turn(%{limit: limit}) when current_marble > limit do

  end

  def play_turn(state) do
    # %{0 => 0}
    # %{0 => 1, 1 => 0}
    # %{0 => 2, 1 => 0, 2 => 1}
    # %{0 => 2, 1 => 3, 2 => 1, 3 => 0}
    # %{0 => 4, 4 => 2, 2 => 1, 1 => 3, 3 => 0}
  end
end
