defmodule Day01.Part1 do

  def run() do
    # I could put IO.inspect with the pipeline in get_result,
    # but I like having my output separate from my calculation.  
    IO.inspect get_result()
  end
 
  defp get_result() do
    "input.txt"
    |> File.stream!()
    |> Stream.map(&to_int/1)
    |> Enum.sum()
  end

  defp to_int(value) do
    value
    |> String.trim_trailing()
    |> String.to_integer()
  end
end

Day01.Part1.run()