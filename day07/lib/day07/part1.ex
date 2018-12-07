defmodule Day07.Part1 do
  alias Day07.FileLoader

  def run(file_name) do
    file_name
    |> FileLoader.load()
    |> Enum.sort()
    |> Enum.map(&parse_into_letters/1)
  end

  def parse_into_letters(line) do
    line
    |> String.split(" ")
    |> Enum.filter(fn word -> String.length(word) == 1 end)
  end
end
