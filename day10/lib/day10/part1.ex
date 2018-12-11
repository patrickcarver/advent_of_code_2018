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
  end

  def apply_velocity(points) do
    points
    |> Enum.map(fn %{position: {x, y}, velocity: {add_x, add_y}} ->
      %{position: {x + add_x, y + add_y}, velocity: {add_x, add_y}}
    end)
  end

  def write_to_file(string_to_write) do
    File.write!("../../txt/output.txt"|> Path.expand(__DIR__), string_to_write)
  end
end
