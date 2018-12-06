defmodule Day05.Part1 do
  alias Day05.FileLoader

  def run(file_name) do
    file_name
    |> FileLoader.load()
    |> create_letter_list()
    |> total_remaining_units()
  end

  def total_remaining_units(letters) do
    letters
    |> Enum.reduce([], &compare/2)
    |> Enum.count()
  end

  defp compare(current, seen) do
    first_in_seen = List.first(seen)
    reacted = can_react?(current, first_in_seen)
    update_seen(seen, current, reacted)
  end

  defp update_seen(seen, current, false) do
    [current | seen]
  end

  defp update_seen(seen, _current, true) do
    tl(seen)
  end

  defp can_react?(_current, nil) do
    false
  end

  defp can_react?(current, first_in_seen) do
    difference(current, first_in_seen) == 32
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
    |> Enum.to_list()
    |> List.first()
    |> String.codepoints()
  end
end
