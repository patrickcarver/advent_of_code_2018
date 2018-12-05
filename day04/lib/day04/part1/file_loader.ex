defmodule Day04.Part1.FileLoader do
  def load(file_name) do
    "../../../txt/" <> file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
  end
end
