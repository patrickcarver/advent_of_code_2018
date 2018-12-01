defmodule Day01.Part2Alt do
  alias __MODULE__

  defstruct [current: 0, seen: MapSet.new]

  def run() do
    # I could put IO.inspect with the pipeline in get_result,
    # but I like having my output separate from my calculation.
    IO.inspect get_result()
  end

  defp get_result() do
      "input.txt"
      |> File.stream!()
      |> Stream.map(&to_int/1)
      |> Stream.cycle()
      |> Enum.reduce_while(%Part2Alt{}, &find_first_frequency_reached_twice/2) 
  end

  defp to_int(value) do
    value
    |> String.trim_trailing()
    |> String.to_integer()
  end

  defp find_first_frequency_reached_twice(frequency, state) do
    result = frequency + state.current

    case MapSet.member?(state.seen, result) do
      true -> 
        {:halt, result}
      false ->
        updated_seen = MapSet.put(state.seen, result)
        updated_state = %Part2Alt{current: result, seen: updated_seen}
        {:cont, updated_state}
    end
  end
end

Day01.Part2Alt.run()