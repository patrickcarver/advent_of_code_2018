defmodule Day09Alt do
  def run(num_players, limit) do
    state = %{
      current_marble: 1,
      turn: 2,
      limit: limit,
      marbles: %{0 => %{counter: 1, clock: 1}, 1 => %{counter: 0, clock: 0}},
      num_players: num_players,
      player: 2,
      scores: %{}
    }


    state
    |> play_turn()

  end


  # init
  # %{
    # 0 => %{counter: 0, clock: 0}
  #}

  # turn = 1, current_marble = 0
  # %{
    # 0 => %{counter: 1, clock: 1},
    # 1 => %{counter: 0, clock: 0}
  #}

  # turn = 2, current_marble = 1
  # %{
    # 0 => %{counter: 1, clock: 2},
    # 2 => %{counter: 0, clock: 1},
    # 1 => %{counter: 2, clock: 0}

  #}

  # turn = 3, current_marble = 2
  # %{
   # 0 => %{counter: 3, clock: 2},
   # 2 => %{counter: 0, clock: 1},
   # 1 => %{counter: 2, clock: 3},
   # 3 => %{counter: 1, clock: 0}
  #}

  # turn = 4, current_marble = 3
  # %{
   # 0 => %{counter: 3, clock: 4},
   # 4 => %{counter: 0, clock: 2},
   # 2 => %{counter: 4, clock: 1},
   # 1 => %{counter: 2, clock: 3},
   # 3 => %{counter: 1, clock: 0}
  #}


  # get current marble
  # current = Map.fetch!(marbles, current_marble)
  # %{counter: 0, clock: 2}
  # get one clock key
  # one_clock_key = current[:clock]
  # 2
  # get one clock map
  # Map.fetch!(marbles, one_clock_key)
  # one_clock_map = %{counter: 4, clock: 1}
  # get two clock key
  # two_clock_key = one_clock_map[:clock]
  # 1
  # get two clock map
  # Map.fetch!(marbles, two_clock_key)
  # two_clock_map = %{counter: 2, clock: 3}
  # create new map, counter: one_clock_key, clock: two_clock_key
  # new_map = %{counter: 2, clock: 1}
  # insert new map into marbles, key = turn
  # Map.put(marbles, turn, new_map)
  # update one_clock_map, clock: turn
  # Map.put(marbles, one_clock_key, %{one_clock_map | clock: turn})
  # update two_clock_map, counter: turn
  # Map.put(marbles, two_clock_key, %{two_clock_map | counter: turn})

  # turn = 5, current_marble = 4
  # %{
   # 0 => %{counter: 3, clock: 4},
   # 4 => %{counter: 0, clock: 2},
   # 2 => %{counter: 4, clock: 5},
   # 5 => %{counter: 2, clock: 1},
   # 1 => %{counter: 5, clock: 3},
   # 3 => %{counter: 1, clock: 0}
  #}

  def play_turn(%{limit: limit, turn: turn} = state) when turn > limit do
    state.scores
    |> Enum.map(fn {_player, score} -> score end)
    |> Enum.max()
  end

  def play_turn(%{turn: turn} = state) when rem(turn, 23) == 0 do
    # lol
    one = state.marbles |> Map.fetch!(state.current_marble) |> Map.fetch!(:counter)
    two = state.marbles |> Map.fetch!(one) |> Map.fetch!(:counter)
    three = state.marbles |> Map.fetch!(two) |> Map.fetch!(:counter)
    four = state.marbles |> Map.fetch!(three) |> Map.fetch!(:counter)
    five = state.marbles |> Map.fetch!(four) |> Map.fetch!(:counter)
    six = state.marbles |> Map.fetch!(five) |> Map.fetch!(:counter)
    seven = state.marbles |> Map.fetch!(six) |> Map.fetch!(:counter)
    eight = state.marbles |> Map.fetch!(seven) |> Map.fetch!(:counter)

    before_map = Map.fetch!(state.marbles, eight)
    new_before = %{before_map | clock: six }
    after_map = Map.fetch!(state.marbles, six)
    new_after = %{after_map | counter: eight}

    new_marbles =
      state.marbles
      |> Map.delete(seven)
      |> Map.put(eight, new_before)
      |> Map.put(six, new_after)

    score_to_add = seven + turn
    prev_score = if state.scores[state.player] == nil, do: 0, else: state.scores[state.player]
    player_score = prev_score + score_to_add
    new_scores = Map.put(state.scores, state.player, player_score)

    new_state = %{ state |
      marbles: new_marbles,
      scores: new_scores,
      player: (if state.player == state.num_players, do: 1, else: state.player + 1),
      turn: state.turn + 1,
      current_marble: six
    }

    play_turn(new_state)
  end

  def play_turn(state) do
    current = Map.fetch!(state.marbles, state.current_marble)
    one_clock_key = current[:clock]
    one_clock_map = Map.fetch!(state.marbles, one_clock_key)
    two_clock_key = one_clock_map[:clock]
    two_clock_map = Map.fetch!(state.marbles, two_clock_key)
    new_map = %{counter: one_clock_key, clock: two_clock_key}

    new_marbles =
      state.marbles
      |> Map.put(state.turn, new_map)
      |> Map.put(one_clock_key, %{one_clock_map | clock: state.turn})
      |> Map.put(two_clock_key, %{two_clock_map | counter: state.turn})

    new_state = %{state |
      marbles: new_marbles,
      turn: state.turn + 1,
      current_marble: state.turn,
      player: (if state.player == state.num_players, do: 1, else: state.player + 1)
    }

    play_turn(new_state)
  end
end
