defmodule Day10.Part1 do
  alias FileLoader

  def run(file_name) do
    file_name
    |> FileLoader.load()
  end
end
