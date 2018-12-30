defmodule Day25.Part1 do
  alias FileLoader

  def run(file_name) do
    file_name
    |> FileLoader.load()
    |> parse()
    |> build_constellations_from_coords([])
    |> merge_constellations([])
  end

  def merge_constellations(unmerged, merged) do
    unmerged
    |> Enum.reduce(merged, fn current, acc ->
      # find a merged constellation I can merge with
      index = Enum.find_index(acc, fn element -> !MapSet.disjoint?(current, element) end)

      if is_nil(index) do
        [current | acc]
      else
        List.update_at(acc, index, & MapSet.union(&1, current))
      end

    end)
  end

  def build_constellations_from_coords(coords, constellations) do
    coords
    |> Enum.reduce(constellations, fn coord, acc ->
      updated = update_constellations(acc, coord)

      if updated == acc do
        [MapSet.new([coord]) | acc]
      else
        updated
      end
    end)
  end

  def update_constellations(constellations, coord) do
    Enum.map(constellations, fn constellation ->
      if Enum.any?(constellation, fn element -> manhattan_distance(element, coord) <= 3 end) do
        MapSet.put(constellation, coord)
      else
        constellation
      end
    end)
  end

  def manhattan_distance({a1, b1, c1, d1}, {a2, b2, c2, d2}) do
    abs(a1 - a2) + abs(b1 - b2) + abs(c1 - c2) + abs(d1 - d2)
  end

  def parse(list) do
    Enum.map(list, fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end
end
