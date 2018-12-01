defmodule Day01.Part2 do
  def run() do
    IO.puts get_result()
  end

  defp get_result() do
    change_list = get_frequency_change_list()
    find_first_frequency_reached_twice(0, change_list, MapSet.new())
  end

  defp get_frequency_change_list() do
      "input.txt"
      |> Path.expand(__DIR__)
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