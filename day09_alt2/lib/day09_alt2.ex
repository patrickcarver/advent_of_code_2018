defmodule Day09Alt2 do

  def process(marble_to_add, acc) when rem(marble_to_add, 23) == 0 do
    current_player = rem(marble_to_add, acc.num_players) - 1
    current_index = acc.last_index - 7
    score = Enum.at(acc.marbles, current_index)
    new_scores = Map.update(acc.scores, current_player, 0, &(&1 + score + marble_to_add))
    new_marbles = Enum.drop(acc.marbles, current_index + 1)
    %{marbles: new_marbles, last_index: 0, scores: new_scores, num_players: acc.num_players }
  end

  def process(marble_to_add, acc) do
    current_index  =
      if length(acc.marbles) - 1 == acc.last_index, do: 1, else: acc.last_index + 2

    new_marbles = List.insert_at(acc.marbles, current_index, marble_to_add)
    %{marbles: new_marbles, last_index: current_index, scores: acc.scores, num_players: acc.num_players}
  end

  def run(players, limit) do
    scores = create_scores(players)

    1..limit
    |> Enum.reduce(%{marbles: [0], last_index: 0, scores: scores, num_players: players}, &process/2)
  end

  def create_scores(players) do
    0..(players-1)
    |> Enum.map(fn item -> {item, 0} end)
    |> Enum.into(%{})
  end
end
