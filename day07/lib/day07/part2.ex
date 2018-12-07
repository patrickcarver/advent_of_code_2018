defmodule Day07.Part2 do
  alias Day07.FileLoader

  def run(file_name) do
    file_name
    |> FileLoader.load()
  end
end

