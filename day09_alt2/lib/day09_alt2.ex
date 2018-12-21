defmodule Day09Alt2 do

  def run(num_players, limit) do
    players = create_players(num_players)

    state = %{
      marbles: [0],
      last_index: 0,
      players: players,
      num_players: num_players
    }

    1..limit
    |> Enum.reduce(state, &process_marble/2)
    |> Map.get(:players)
    |> Enum.map(fn {_index, score} -> score end)
    |> Enum.max()
  end

  # current_player = rem(marble_to_add - 1, state.num_players)

  def get_mod_23_index(%{marbles: marbles, last_index: last_index}) do
    len = length(marbles)

    if last_index < 7 do
      len + (last_index - 7)
    else
      last_index - 7
    end
  end

  def process_marble(marble_to_add, state) when rem(marble_to_add, 23) == 0 do
    index = get_mod_23_index(state)
    {score_to_add, new_marbles} = List.pop_at(state.marbles, index)
    current_player = rem(marble_to_add - 1, state.num_players)
    player_score = state.players[current_player]
    updated_score = player_score + score_to_add + marble_to_add
    updated_players = Map.put(state.players, current_player, updated_score)
    %{state | marbles: new_marbles, last_index: index, players: updated_players}
  end

  def process_marble(marble_to_add, state) do
    index = if Enum.at(state.marbles, state.last_index + 1) == nil, do: 1, else: state.last_index + 2
    new_marbles = List.insert_at(state.marbles, index, marble_to_add)
    %{state | marbles: new_marbles, last_index: index}
  end

  def create_players(num_players) do
    0..(num_players-1)
    |> Enum.reduce(%{}, fn num, acc -> Map.put(acc, num, 0) end)
  end
end
