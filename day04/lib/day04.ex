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
defmodule Day04 do
  def run(part: part, mode: mode) do
    input_file =
      case mode do
        "prod" -> "input.txt"
        _ -> "test.txt"
      end

    case part do
      1 -> Day04.Part1.run(input_file)
      _ -> nil
    end
  end
end
