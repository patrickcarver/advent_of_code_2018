defmodule Day05.Part1 do
  alias Day05.FileLoader

  def run(file_name) do
    file_name
    |> FileLoader.load()
    |> create_letter_list()
    |> Enum.reduce([], fn current, seen  ->
      first_in_seen = List.first(seen)

      if first_in_seen == nil do
        [current | seen]
      else
        if can_react?(current, first_in_seen) do
          [_ | tail] = seen
          tail
        else
          [current | seen]
        end
      end
    end)
    |> Enum.count()
  end





  defp can_react?(first, second) do
    difference(first, second) == 32
  end

  defp difference(first, second) do
    abs(ascii(first) - ascii(second))
  end

  defp ascii(letter) do
    letter
    |> String.to_charlist()
    |> hd
  end

  defp create_letter_list(file_stream) do
    file_stream
    |> Enum.map(&String.trim_trailing/1)
    |> List.first()
    |> String.codepoints()
  end
end
