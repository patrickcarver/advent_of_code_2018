defmodule Day10.Part1 do
  alias FileLoader

  defmodule Parser do
    def create_points(list) do
      list
      |> Enum.map(fn line ->
        line
        |> String.replace(" ", "")
        |> String.split(">")
        |> Enum.reject(fn token -> token == "" end)
        |> Enum.map(fn data ->
          [label, coords] = data |> String.split("=<")
          new_label = label |> String.to_atom()
          new_coords = coords |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
          {new_label, new_coords}
        end)
        |> Enum.into(%{})
      end)
    end
  end

  def run(file_name) do
    file_name
    |> FileLoader.load()
    |> Parser.create_points()
    |> loop()
    |> prep_to_write()
  #  |> write_to_file()
  end

  def write_to_file(string_to_write) do
    File.write!("../../txt/output.txt"|> Path.expand(__DIR__), string_to_write)
  end

  def prep_to_write(points) do
    positions = points |> Enum.map(fn %{position: position} -> position end)

  #  sorted_by_y = positions |> Enum.sort(fn {_, first}, {_, second} -> first <= second end)
  #  smallest_y = sorted_by_y |> List.first |> elem(1)
  #  biggest_y = sorted_by_y |> List.last |> elem(1)

  #  sorted_by_x = positions |> Enum.sort(fn {first, _}, {second, _} -> first <= second end)
  #  smallest_x = sorted_by_x |> List.first |> elem(0)
  #  biggest_x = sorted_by_x |> List.last |> elem(0)

  #  width = abs(biggest_x) + abs(smallest_x)
  #  height = abs(biggest_y) + abs(smallest_y)

 #   translated_positions = positions
 #   |> Enum.map(fn {x, y} -> {x - smallest_x, abs(y - biggest_y)} end)
 #   |> Enum.sort(fn {first, _}, {second, _} -> first <= second end)
 #   |> Enum.sort(fn {_, first}, {_, second} -> first <= second end)

 #   grid = init_grid(width, height)

 #   translated_positions
 #   |> Enum.reduce(grid, fn {x, y}, acc ->
 #    new_row = Enum.at(acc, y) |> List.replace_at(x, "#{y}")
 #    List.replace_at(acc, y, new_row)
 #   end)
  #  |> Enum.map(fn row -> Enum.join(row, "") end)
  #  |> Enum.join("\n")

  end

  def init_grid(width, height) do
    for y <- 0..height, do: List.duplicate(" ", width + 1)
  end

  def loop(prev_points) do
    new_points = prev_points |> apply_velocity
    prev_size = get_bounding_box_size(prev_points)
    new_size = get_bounding_box_size(new_points)

    if prev_size > new_size do
      loop(new_points)
    else
      prev_points
    end
  end

  defp get_bounding_box_size(points) do
    positions = points |> Enum.map(fn %{position: position} -> position end)

    sorted_by_y = positions |> Enum.sort(fn {_, first}, {_, second} -> first <= second end)
    smallest_y = sorted_by_y |> List.first |> elem(1)
    biggest_y = sorted_by_y |> List.last |> elem(1)

    sorted_by_x = positions |> Enum.sort(fn {first, _}, {second, _} -> first <= second end)
    smallest_x = sorted_by_x |> List.first |> elem(0)
    biggest_x = sorted_by_x |> List.last |> elem(0)

    width = abs(biggest_x) + abs(smallest_x)
    height = abs(biggest_y) + abs(smallest_y)

    width * height
  end

  def apply_velocity(points) do
    points
    |> Enum.map(fn %{position: {x, y}, velocity: {add_x, add_y}} ->
      %{position: {x + add_x, y + add_y}, velocity: {add_x, add_y}}
    end)
  end
end
