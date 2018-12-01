defmodule Day01.Part1 do
  # Run in iex
  
  def run() do
    "input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&(&1 |> String.trim_trailing() |> String.to_integer()))
    |> Enum.reduce(0, fn num, acc -> num + acc end)
  end
end