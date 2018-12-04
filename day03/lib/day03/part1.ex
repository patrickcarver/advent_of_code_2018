defmodule Day03.Part1 do

  def run() do
    "../../txt/input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(fn line ->
        line 
        |> String.trim_trailing()
        |> String.split(" @ ")
        |> List.last()
        |> String.split(": ")
        |> create_claim()
    end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn coord, acc -> Map.update(acc, coord, 1, &(&1 + 1)) end)
    |> Map.values()
    |> Enum.reject(fn value -> value == 1 end)
    |> length
  end

  defp create_claim([start, size]) do
    {start_x, start_y} = create_start_coords(start)
    {width, height} = create_size_data(size)
    {end_x, end_y} = {start_x + width - 1, start_y + height - 1}

    for x <- start_x..end_x, y <- start_y..end_y do
      {x,y}
    end
  end

  defp create_start_coords(start) do
    create_tuple_of_integers(start, ",")
  end

  defp create_size_data(size) do
    create_tuple_of_integers(size, "x")
  end

  defp create_tuple_of_integers(string, splitter) do
    string
    |> String.split(splitter)
    |> Enum.map(&String.to_integer/1) 
    |> List.to_tuple()  
  end  
end