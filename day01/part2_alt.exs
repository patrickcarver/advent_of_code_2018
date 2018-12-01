defmodule Day01.Part2Alt do
  defstruct [current: 0, seen: MapSet.new]

  def run() do
    # I could put IO.inspect with in the pipeline in get_result,
    # but I like having my output separate from my calculation.
    IO.inspect get_result()
  end

  defp get_result() do
      "input.txt"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.map(&(&1 |> String.trim_trailing() |> String.to_integer()))
      |> Stream.cycle()
      |> Enum.reduce_while(%__MODULE__{}, &find_first_frequency_reached_twice/2) 
  end

  defp find_first_frequency_reached_twice(frequency, state) do
    result = frequency + state.current

    case MapSet.member?(state.seen, result) do
      true -> 
        { :halt, result }
      false ->
        new_seen = MapSet.put(state.seen, result)
        new_state = %__MODULE__{current: result, seen: new_seen}
        { :cont, new_state }
    end
  end
end

Day01.Part2Alt.run()