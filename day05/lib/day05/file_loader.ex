defmodule Day05.FileLoader do
  def load(file_name) do
    "../../txt/" <> file_name
    |> Path.expand(__DIR__)
    |> File.stream!([], :line)
  end
end
