defmodule Day01.Part1 do
  def run() do
    "input.txt"
    |> File.stream!()
    |> Stream.map(&(&1 |> String.trim_trailing() |> String.to_integer()))
    |> Enum.reduce(0, fn num, acc -> num + acc end)
    |> IO.puts
  end
end

Day01.Part1.run()