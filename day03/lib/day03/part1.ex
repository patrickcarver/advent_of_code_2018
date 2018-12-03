defmodule Day03.Part1 do
  alias Day03.Parser

  def run() do
    "../../txt/input.txt"
    |> Parser.parse()
  end

  def create_claim_coords(%{start: {start_x, start_y}, size: {width, height}}) do
    for x <- start_x..width, y <- start_y..height, do: {x, y}
  end
end