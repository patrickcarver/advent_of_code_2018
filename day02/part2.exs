defmodule Day02.Part2 do
  def run() do
    create_list() |> process() |> IO.inspect()
  end

  defp process([head | tail]) do
    result = tail
             |> Enum.map(fn candidate -> 
                  zipped = Enum.zip(head, candidate)
                  diff = Enum.reject(zipped, fn {first, second} -> first == second end) |> Kernel.length
                  {zipped, diff} 
                end)
             |> Enum.filter(fn {_zipped, diff} -> diff == 1 end)
             |> List.first

    if result == nil do
      process(tail)
    else
     { zipped, _diff }  = result
     zipped 
     |> Enum.filter(fn {first, second} -> first == second end)
     |> Enum.map(fn {first, _second} -> first end)
     |> Enum.join()
    end
  end

  defp create_list() do
    "input.txt"
    |> File.stream!()
    |> Stream.map(&split_into_letters/1)
    |> Enum.to_list()      
  end

  defp split_into_letters(value) do
    value
    |> String.trim_trailing()
    |> String.codepoints()
  end  
end

Day02.Part2.run()