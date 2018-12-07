defmodule Day06.FileLoader do
  def load(file_name) do
    "../../txt/" <> file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
  end
end
