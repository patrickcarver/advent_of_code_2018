defmodule Day06.FileLoader do
  def load(file_name) do
    "../../txt/" <> file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.to_list()
  end
end
