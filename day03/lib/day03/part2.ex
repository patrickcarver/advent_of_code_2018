defmodule Day03.Part2 do

  def run() do
    "../../txt/input.txt"
    |> FileLoader.load()
    |> Claims.create()
    |> IdCountList.create()
    |> OnlyNonOverlappedClaim.find()
  end   

  defmodule FileLoader do
    def load(file_name) do
      file_name
      |> Path.expand(__DIR__)
      |> File.stream!()
    end  
  end

  defmodule Claims do
    def create(file_stream) do
      file_stream
      |> Enum.map(&create_claim/1)
      |> List.flatten()    
    end

    defp create_claim(line) do
      [id, data] = get_id_and_data(line)
      [start, size] = String.split(data, ": ")
      [start_x, start_y] = get_start_data(start)
      [width, height] = get_size_data(size)
      x_range = start_x..(start_x + width - 1)
      y_range = start_y..(start_y + height - 1)

      for x <- x_range, y <- y_range do
        {id, x, y}
      end    
    end

    defp get_id_and_data(line) do
      line |> String.trim_trailing() |> String.split(" @ ")
    end    

    defp get_start_data(start) do
      start |> split_by(",")
    end

    defp get_size_data(size) do
      size |> split_by("x")
    end

    defp split_by(value, splitter) do
      value |> String.split(splitter) |> Enum.map(&String.to_integer/1)
    end
  end

  defmodule IdCountList do
    def create(claims) do
      claims
      |> Enum.reduce(%{}, &create_map_of_ids/2)
      |> Map.values()    
    end

    defp create_map_of_ids({id, x, y}, acc) do
      Map.update(acc, {x, y}, [id], &([id | &1]))
    end
  end

  defmodule OnlyNonOverlappedClaim do
    def find(id_list) do
      id_list
      |> get_only_non_overlapped()
      |> List.first
      |> String.replace("#", "")
      |> String.to_integer()          
    end

    defp get_only_non_overlapped(id_list) do
      only_one = find_lists_with_only_one(id_list)
      multiple = find_lists_with_multiple(id_list)
      only_one -- multiple      
    end

    defp find_lists_with_only_one(id_list) do
      discriminate(id_list, &Enum.filter/2) 
    end

    defp find_lists_with_multiple(id_list) do
      discriminate(id_list, &Enum.reject/2) 
    end

    defp discriminate(id_list, discriminator) do
      id_list 
      |> discriminator.(fn list -> length(list) == 1 end) 
      |> List.flatten() 
      |> Enum.uniq      
    end
  end
end