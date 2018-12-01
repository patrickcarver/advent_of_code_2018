defmodule Day01.Part1 do
  def run() do
    "input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.reduce(0, fn num, acc -> num + acc end)
  end
end