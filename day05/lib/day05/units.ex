defmodule Day05.Units do
  alias Day05.FileLoader

  def create(file_name) do
    file_name
    |> FileLoader.load()
    |> List.first()
    |> String.codepoints()
  end

  def total_after_all_reacted(units) do
    units
    |> react_all()
    |> Enum.count()
  end

  defp react_all(units) do
    Enum.reduce(units, [], &compare/2)
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
end
