defmodule Day23.Part2 do
  alias FileLoader

  def run(file_name) do
    nanobots = load_nanobots(file_name)

    nanobots
    |> Enum.map(fn nanobot ->
      total_in_range = get_total_in_range(nanobot, nanobots)
      Map.put(nanobot, :total_in_range, total_in_range)
    end)
    |> Enum.max_by(fn %{total_in_range: total_in_range} -> total_in_range end)
    |> Map.get(:position)
    |> manhattan_distance({0,0,0})



  end

 # def sort_by_total_in_range(nanobots) do
 #   nanobots
 #   |> Enum.sort(
 #     fn %{total_in_range: first}, %{total_in_range: second} -> first >= second
 #   end)
 # end

  def get_total_in_range(nanobot, nanobots) do
    Enum.reduce(nanobots, 0, fn selected, acc ->
      in_range? = manhattan_distance(nanobot.position, selected.position) <= nanobot.radius

      if in_range?, do: acc + 1, else: acc
    end)
  end

  def manhattan_distance({a1, b1, c1}, {a2, b2, c2}) do
    abs(a1 - a2) + abs(b1 - b2) + abs(c1 - c2)
  end

  def get_positions(nanobots) do
    nanobots
    |> Enum.map(fn %{position: position} -> position end)
  end

  def load_nanobots(file_name) do
    file_name
    |> FileLoader.load()
    |> parse()
  end

  def parse(list) do
    list
    |> Enum.map(fn line ->
      [pos, rad] = line |> String.split(", ")

      %{
        position: parse_position(pos),
        radius: parse_radius(rad)
      }
    end)
  end

  def parse_position(pos) do
    pos
    |> String.replace("pos=<", "")
    |> String.replace(">", "")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def parse_radius(rad) do
    rad
    |> String.replace("r=", "")
    |> String.to_integer()
  end
end

