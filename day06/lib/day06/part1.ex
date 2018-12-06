defmodule Day06.Part1 do
  alias Day06.FileLoader

  def run(file_name) do
    file_name
    |> FileLoader.load()
  end
end
