defmodule Day23.Part1 do
  alias FileLoader

  def run(file_name) do
    nanobots = load_nanobots(file_name)
    strongest = find_strongest_nanobot(nanobots)

    nanobots
    |> get_positions()
    |> Enum.reduce(0, fn position, acc ->
      in_range? = manhattan_distance(strongest.position, position) <= strongest.radius

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

  def find_strongest_nanobot(nanobots) do
    nanobots
    |> Enum.max_by(fn %{radius: radius} -> radius end)
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
