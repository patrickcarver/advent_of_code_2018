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
    first_points = init_points(file_name)
    first_bounding_box = get_bounding_box(first_points)

    first_points
    |> loop(first_bounding_box, 0)
    |> create_graphics()
    |> write_to_file()
  end

  def init_grid({width, height}) do
    for y <- 0..height, do: List.duplicate(".", width + 1)
  end

  def get_dimensions(bounding_box) do
    width = abs(bounding_box.biggest_x) + abs(bounding_box.smallest_x)
    height = abs(bounding_box.biggest_y) + abs(bounding_box.smallest_y)

    {width, height}
  end

  def create_graphics({positions, bounding_box}) do
    grid = bounding_box |> get_dimensions() |> init_grid()

    positions
    |> Enum.reduce(grid, fn {x, y}, acc ->
        new_row = Enum.at(acc, y) |> List.replace_at(x, "#")
        List.replace_at(acc, y, new_row)
    end)
    |> Enum.map(fn row -> Enum.join(row, "") end)
    |> Enum.join("\n")
  end

  def translate_to_display({positions, bounding_box}) do
    min_x = bounding_box.smallest_x
    min_y = bounding_box.smallest_y

    translated =
      positions
      |> Enum.map(fn {x, y} ->
          new_x = cond do
            x > 0 -> x - abs(min_x)
            x <= 0 -> x + abs(min_x)
          end

          new_y = cond do
            y > 0 -> y - abs(min_y)
            y <= 0 -> + abs(min_y)
          end

          {new_x, new_y}
      end)

      {translated, bounding_box}
  end

# current is completely inside prev, keep going
# current is not complete inside prev, return prev

  def loop(prev_points, prev_bounding_box, seconds) do
    new_points = apply_velocities(prev_points)
    new_bounding_box = get_bounding_box(new_points)

    if is_not_inside_of(new_bounding_box, prev_bounding_box) do
      positions = prev_points |> Enum.map(fn %{position: position} -> position end)
      IO.inspect seconds
      {positions, prev_bounding_box}
    else
      loop(new_points, new_bounding_box, seconds + 1)
    end
  end

  def init_points(file_name) do
    file_name
    |> FileLoader.load()
    |> Parser.create_points()
  end


  #def translate_points_for_display(points) do
  #
  #end

  # current is completely inside prev, keep going
# current is not complete inside prev, return prev


  def is_not_inside_of(current, prev) do
    current.biggest_y > prev.biggest_y ||
    current.smallest_y < prev.smallest_y ||
    current.biggest_x > prev.biggest_x ||
    current.smallest_x < prev.smallest_x
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
