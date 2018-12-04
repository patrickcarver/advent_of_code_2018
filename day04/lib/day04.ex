defmodule Day04 do
  alias Day04.Part1

  def run(part: part) do
    input_file = "input.txt"
    case part do
      1 -> Part1.run(input_file)
      _ -> nil
    end
  end
end
