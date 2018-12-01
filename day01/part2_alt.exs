defmodule Day01.Part2Alt do
  # Run in iex

  defstruct [current: 0, seen: MapSet.new]

  def run() do
    get_frequency_change_stream()
    |> Enum.reduce_while(%__MODULE__{}, &find_first_frequency_reached_twice/2) 
  end

  defp get_frequency_change_stream() do
      "input.txt"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.map(&(&1 |> String.trim_trailing() |> String.to_integer()))
      |> Stream.cycle()
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