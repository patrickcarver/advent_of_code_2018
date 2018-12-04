defmodule Day04.Part1Test do
  use ExUnit.Case

  alias Day04.Part1

  test "Part1 returns the answer 240" do
    assert Part1.run("test.txt") == 240
  end

end
