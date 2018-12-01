defmodule Day01.Part2 do
  def run() do
    # I could put IO.inspect with in the pipeline in get_result,
    # but I like having my output separate from my calculation.
    IO.inspect get_result()
  end

  defp get_result() do
    change_list = get_frequency_change_list()
    find_first_frequency_reached_twice(0, change_list, MapSet.new())
  end

  defp get_frequency_change_list() do
      "input.txt"
      |> File.stream!()
      |> Stream.map(&(&1 |> String.trim_trailing() |> String.to_integer()))
      |> Enum.to_list()
  end

  defp find_first_frequency_reached_twice(current, change_list, stored) do
    [change | tail] = change_list
    result = current + change
    
    case MapSet.member?(stored, result) do
      true -> 
        result
      false ->
        updated_change_list = tail ++ [change]
        updated_stored = MapSet.put(stored, result)
        find_first_frequency_reached_twice(result, updated_change_list, updated_stored)
    end
  end
end

Day01.Part2.run()