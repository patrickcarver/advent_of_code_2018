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
    |> init_points()
  end

  def init_points(file_name) do
    file_name
    |> FileLoader.load()
    |> Parser.create_points()
  end


  #def translate_points_for_display(points) do
  #
  #end

  def get_bounding_box_size(bounding_box) do
    width = abs(bounding_box.smallest_x - bounding_box.biggest_x)
    height = abs(bounding_box.smallest_y - bounding_box.biggest_y)
    width * height
  end

  def get_smallest(first, second), do: if first <= second, do: first, else: second
  def get_biggest(first, second), do: if first > second, do: first, else: second

  def get_bounding_box(points) do
    bounding_box =
      %{smallest_x: 0, smallest_y: 0, biggest_x: 0, biggest_y: 0}

    points
    |> Enum.reduce(bounding_box, fn %{position: {x, y}}, acc ->
      new_smallest_x = get_smallest(x, acc.smallest_x)
      new_smallest_y = get_smallest(y, acc.smallest_y)
      new_biggest_x = get_biggest(x, acc.biggest_x)
      new_biggest_y = get_biggest(y, acc.biggest_y)

      %{
        smallest_x: new_smallest_x,
        smallest_y: new_smallest_y,
        biggest_x: new_biggest_x,
        biggest_y: new_biggest_y
      }
    end)
  end

  def write_to_file(string_to_write) do
    File.write!("../../txt/output.txt"|> Path.expand(__DIR__), string_to_write)
  end

  def apply_velocities(points) do
    points
    |> Enum.map(&apply_velocity/1)
  end

  def apply_velocity(%{position: {x, y}, velocity: {add_x, add_y}}) do
    %{position: {x + add_x, y + add_y}, velocity: {add_x, add_y}}
  end
end
