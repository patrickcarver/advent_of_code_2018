defmodule Day09Alt do

  defmodule Part1 do
    defmodule PlayerCycle do
      def create(num_players) do
        Enum.zip(1..num_players, List.duplicate(0, num_players))
      end

      def rotate(cycle) do
        [head | tail] = cycle
        tail ++ [head]
      end

    end


    def add_marble(marble_to_add, %{marbles: marbles, index_to_add: index_to_add, players: players}) when rem(marble_to_add, 23) == 0 do
      current_index = index_to_add - 7 - 2

      {score, new_marbles} = List.pop_at(marbles, current_index)

      [{player_id, high_score} | rest] = players

      new_high_score = high_score + marble_to_add + score

      new_players = rest ++ [{player_id, new_high_score}]

      %{marbles: new_marbles, index_to_add: current_index + 2, players: new_players}
    end

    def add_marble(marble_to_add, %{marbles: marbles, index_to_add: index_to_add, players: players}) do
      new_marbles = List.insert_at(marbles, index_to_add, marble_to_add)
      next_index_to_add =
        if List.last(new_marbles) == marble_to_add, do: 1, else: index_to_add + 2

      new_players = PlayerCycle.rotate(players)

      %{marbles: new_marbles, index_to_add: next_index_to_add, players: new_players}
    end

    def run(num_players, limit) do
      players = PlayerCycle.create(num_players)

      1..limit
      |> Enum.reduce(%{marbles: [0], index_to_add: 1, players: players}, &add_marble/2)
    end

    def get_highest_score(%{players: players}) do
      players |> Enum.reduce(0, fn {_id, score}, high_score ->
        if score > high_score, do: score, else: high_score
      end)
    end
  end

end
