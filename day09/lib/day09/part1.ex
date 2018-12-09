defmodule Day09.Part1 do
  def run() do
    limit = 25
    marbles = []
    current = 1
    high_score = 0

    loop(marbles, current, limit, high_score)
  end

  # final iteration, current = limit
  def loop(marbles, current, limit, high_score) when current > limit do

  end

  # when current is a multiple of 23, rem(current) == 0
  def loop(marbles, current, limit, high_score) when rem(current, 23) == 0 do

    loop(marbles, current + 1, limit, high_score)
  end

  # regular iteration
  def loop(marbles, current, limit, high_score) do

    loop(marbles, current + 1, limit, high_score)
  end
end
