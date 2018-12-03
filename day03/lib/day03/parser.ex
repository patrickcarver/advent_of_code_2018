defmodule Day03.Parser do
  def parse(input) do
    input
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(fn line ->
        line 
        |> String.trim_trailing()
        |> String.split(" @ ")
        |> List.last()
        |> String.split(": ")
        |> create_claim()
    end)
    |> Enum.to_list()
  end

  defp create_claim([start, size]) do
    {x, y} = create_start_coords(start)
    {width, height} = create_size_data(size)

    %{start: {x, y}, size: {width, height}}
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