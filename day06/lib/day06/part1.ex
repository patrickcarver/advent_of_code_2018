defmodule Day06.Part1 do
  alias Day06.FileLoader

  def run(file_name) do
    inputs = get_inputs(file_name)

    bounds = find_bounds(inputs)

    coords = generate_coords(bounds, inputs)

    counts = create_map(inputs)

  #  map = create_map(inputs)
    Enum.map(coords, fn coord ->
      distances = Enum.map(inputs, fn input -> manhattan_distance(coord, input) end)
      zipped = Enum.zip(inputs, distances)
               |> Enum.sort(fn { _, distance1 }, {_, distance2 } -> distance1 <= distance2 end)

      [{input1, distance1}, {_input2, distance2}] = Enum.take(zipped, 2)

      key = if distance1 != distance2, do: input1, else: :tied
      {key, coord}
    end)
    |> Enum.reduce(counts, fn {key, value}, acc ->
      list = Map.get(acc, key)
      new_value = [value | list]
      Map.put(acc, key, new_value)
    end)
    |> Enum.reject(fn {_key, coords} ->
      {x_min..x_max, y_min..y_max} = bounds
      Enum.any?(coords, fn [x, y] -> x in [x_min, x_max] || y in [y_min, y_max] end)
    end)
    |> Enum.map(fn {_input, coords} -> Enum.count(coords) + 1 end)
    |> Enum.max()

#    |> Enum.map(fn {key, value} -> {key, Enum.count(value) + 1} end)
#    |> Enum.reduce(%{}, fn {key, value}, acc -> Map.put(acc, key, value) end)
#    |> Map.delete(:tied)

# are any coords on the edge?



    # create map with inputs as keys, init value empty list that will store coords that are closest to input

    # iterate each coords in bounds
      # calculate manhattan distance between coord and all inputs -> list
      # sort results
      # if the first and second elements in results are equal, then it is tied -> throw away
      # otherwise
  end

  def create_map(inputs) do
    map = Enum.reduce(inputs, %{}, fn coord, map ->
      Map.put(map, coord, [])
    end)

    Map.put(map, :tied, [])
  end

  def generate_coords({x_range, y_range}, inputs) do
    for x <- x_range, y <- y_range, [x, y] not in inputs, do: [x, y]
  end

  def find_bounds(inputs) do
    [x_min, x_max] = find_bounds_for_axis(inputs, &sort_by_x/2, &get_x/1)
    [y_min, y_max] = find_bounds_for_axis(inputs, &sort_by_y/2, &get_y/1)

    {x_min..x_max, y_min..y_max}
  end

  def find_bounds_for_axis(inputs, sorter, getter) do
    inputs
    |> Enum.sort(sorter)
    |> Enum.min_max()
    |> Tuple.to_list()
    |> Enum.map(getter)
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

