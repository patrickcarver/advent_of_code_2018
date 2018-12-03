defmodule Day03.ParserTest do
  use ExUnit.Case

  alias Day03.Parser

  setup_all do
    parsed_list = Parser.parse("../../txt/input.txt")

    {:ok, parsed_list: parsed_list}
  end

  test "Parser returns a list of 1411 elements", context do
    assert context[:parsed_list] |> length == 1411
  end

  test "First item should be %{start: {56, 249}, size: {24, 16}}", context do
    actual = context[:parsed_list] |> List.first
    expected = %{start: {56, 249}, size: {24, 16}}
    assert actual == expected
  end
end