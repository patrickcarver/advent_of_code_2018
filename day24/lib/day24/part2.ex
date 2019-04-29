defmodule Day24.Part2 do
  alias FileLoader

  def run(file_name) do
    file_name
    |> FileLoader.load()
    |> parse_data()
  end

  def parse_data(list) do
    list
  end
end
