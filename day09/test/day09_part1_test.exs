defmodule Day09.Part1Test do
  use ExUnit.Case

  alias Day09.Part1



  test "create a cycle of 10 players" do
    actual = Part1.create_cycle(10)
    expected = [
      {1, 0},
      {2, 0},
      {3, 0},
      {4, 0},
      {5, 0},
      {6, 0},
      {7, 0},
      {8, 0},
      {9, 0},
      {10, 0}
    ]

    assert actual == expected
  end

  test "run when players are 30 and limit is 5807" do
    actual = Part1.run(30, 5807)
    expected = 37305

    assert actual == expected
  end

  test "run when players are 21 and limit is 6111" do
    actual = Part1.run(21, 6111)
    expected = 54718

    assert actual == expected
  end

  test "run when players are 17 and limit is 1104" do
    actual = Part1.run(17, 1104)
    expected = 2764

    assert actual == expected
  end

  test "run when players are 13 and limit is 7999" do
    actual = Part1.run(13, 7999)
    expected = 146373

    assert actual == expected
  end

  test "run when players are 10 and limit is 1618" do
    actual = Part1.run(10, 1618)
    expected = 8317

    assert actual == expected
  end


end
