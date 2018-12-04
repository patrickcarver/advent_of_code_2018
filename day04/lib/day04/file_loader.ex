defmodule Day04.FileLoader do
  def load(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
  end
end
