defmodule Day02.Part1 do
  def run() do
    "input.txt"
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.to_list()
    |> Enum.map(fn line -> 
      line
      |> String.codepoints()
      |> Enum.sort()
      |> Enum.chunk_by(&(&1))
      |> Enum.reject(&(length(&1) == 1))
      |> Enum.map(&length/1)
      |> Enum.uniq()
    end)
    |> Enum.reduce(%{two: 0, three: 0}, &accumulate/2)
    |> (&(&1.two * &1.three)).()
    |> IO.inspect
  end

  defp accumulate(list, map) do
    case { Enum.member?(list, 2), Enum.member?(list, 3) } do
      { true, true } -> %{two: map.two + 1, three: map.three + 1}
      { false, true } -> %{map | three: map.three + 1}
      { true, false } -> %{map | two: map.two + 1}
      { false, false } -> map
    end
  end

 # defp accumulate([2], map), do: Map.update!(map, :two, &(&1 + 1))
 # defp accumulate([3], map), do: Map.update!(map, :three, &(&1 + 1))
 # defp accumulate(list, map) when length(list) == 2, do: %{two: map.two + 1, three: map.three + 1}
 # defp accumulate(_list, map), do: map
end

Day02.Part1.run()