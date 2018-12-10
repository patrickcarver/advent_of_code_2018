defmodule Day09.Part1 do
  def run(players, limit) do
    cycle = create_cycle(players)

    loop([], 0, 1, limit, cycle)
    |> elem(1)
    |> Enum.reduce(0, fn player, acc ->
      {_player_id, score } = player
      if score > acc, do: score, else: acc
    end)
  end

  def create_cycle(players) do
    Enum.zip(1..players, List.duplicate(0, players))
  end



  # final
  def loop(marbles, _current_index, marble_to_add, limit, cycle) when marble_to_add > limit do
    { marbles, cycle }
  end

  # empty marbles
  def loop([], current_index, marble_to_add, limit, cycle) do
     loop([0], current_index, marble_to_add, limit, cycle)
  end

  def loop([0], current_index, marble_to_add, limit, cycle) do
    new_cycle = move_to_next_in_cycle(cycle)
    loop([0,1], current_index + 2, marble_to_add + 1, limit, new_cycle)
  end

  def loop([0, 1], current_index, marble_to_add, limit, cycle) do
    new_cycle = move_to_next_in_cycle(cycle)
    loop([0,2,1], current_index + 2, marble_to_add + 1, limit, new_cycle)
  end

  # when the marble_to_add is a multiple of 23
  def loop(marbles, current_index, marble_to_add, limit, cycle)
    when rem(marble_to_add, 23) == 0 and current_index != 0 do
    # current_index - 7 - 2 # 7 from the rules, 2 to compensate for prev iteration
    index_for_target = current_index - 7 - 2

    score = Enum.at(marbles, index_for_target)

    [player | rest] = cycle
    {player_id, player_score } = player

    new_player_score = player_score + score + marble_to_add

    new_cycle = rest ++ [{player_id, new_player_score}]

    new_marbles = List.delete_at(marbles, index_for_target)

    loop(new_marbles, index_for_target + 2, marble_to_add + 1, limit, new_cycle)
  end

  # iterate
  def loop(marbles, current_index, marble_to_add, limit, cycle) do
    # marble to add needs to go to the current_index
    new_marbles = List.insert_at(marbles, current_index, marble_to_add)

    next_index = if List.last(new_marbles) == marble_to_add, do: 1, else: current_index + 2

    new_cycle = move_to_next_in_cycle(cycle)

    loop(new_marbles, next_index, marble_to_add + 1, limit, new_cycle)
  end

  def move_to_next_in_cycle(list) do
    [first | rest] = list
    rest ++ [first]
  end
end
