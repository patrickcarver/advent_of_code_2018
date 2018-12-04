defmodule Day04Test do
  use ExUnit.Case

  alias DayO4.{FileLoader, Part1}

  setup_all do
    { :ok, file_name: "../../txt/test.txt" }
  end

  test "Day04.Part1.do_run loads from test.txt", context do
    actual = Part1.do_run(context[:file_name])
    refute actual == nil
  end
end
