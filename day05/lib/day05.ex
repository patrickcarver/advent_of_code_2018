defmodule Day05 do
  def run(part: part, mode: mode) do
    input_file =
      case mode do
        :prod -> "input.txt"
        _ -> "test.txt"
      end

    case part do
      1 -> Day05.Part1.run(input_file)
      #2 -> Day05.Part2.run(input_file)
      _ -> nil
    end
  end
end
