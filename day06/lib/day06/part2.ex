defmodule Day06.Part2 do
  alias Day06.FileLoader

  def run(file_name) do
    inputs = get_inputs(file_name)
    bounds = find_bounds(inputs)
    coords = generate_coords(bounds, inputs)


    max_distance = 10_000

    Enum.map(coords, fn coord ->
      sum_distances =
        inputs
        |> Enum.reduce(0, fn input, sum -> manhattan_distance(coord, input) + sum end)
    end)
    |> Enum.filter(fn distance -> distance < max_distance end)
    |> Enum.count()

  end



  def generate_coords({x_range, y_range}, inputs) do
    for x <- x_range, y <- y_range, do: [x, y]
  end

  def find_bounds(inputs) do
    [x_min, x_max] = find_bounds_for_axis(inputs, &sort_by_x/2, &get_x/1)
    [y_min, y_max] = find_bounds_for_axis(inputs, &sort_by_y/2, &get_y/1)

    {x_min..x_max, y_min..y_max}
  end

  def find_bounds_for_axis(inputs, sorter, getter) do
    inputs
    |> Enum.sort(sorter)
    |> Enum.map(getter)
    |> Enum.min_max()
    |> Tuple.to_list()
  end

  def get_x([x, _]), do: x
  def get_y([_, y]), do: y

  def sort_by_x([x0, _], [x1, _]), do: x0 <= x1
  def sort_by_y([_, y0], [_, y1]), do: y0 <= y1

  def get_inputs(file_name) do
    file_name
    |> FileLoader.load()
    |> Enum.map(fn str -> str |> String.split(", ") |> Enum.map(&String.to_integer/1) end)
  end

  def manhattan_distance([x0, y0], [x1, y1]) do
    abs(x0 - x1) + abs(y0 - y1)
  end
end

