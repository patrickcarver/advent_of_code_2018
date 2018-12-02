defmodule Day02.Part2 do
  def run() do
    # Trying out leaving IO.inspect in the pipeline
    create_list() |> process() |> IO.inspect()
  end

  defp process([head | tail]) do
    result = find_with_difference_of_one_letter(head, tail)

    if result == nil do
      process(tail)
    else
      zipped = elem(result, 0)
      answer(zipped)
    end
  end

  # answer is asgwjcmzredihqoutcylvzinx

  defp find_with_difference_of_one_letter(head, tail) do
    tail
    |> Enum.map(fn candidate -> 
        zipped = Enum.zip(head, candidate)
        diff = Enum.reject(zipped, &do_tuple_elements_match?/1) |> Kernel.length
        {zipped, diff} 
      end)
    |> Enum.filter(fn {_zipped, diff} -> diff == 1 end)
    |> List.first  
  end

  defp do_tuple_elements_match?({first, second}), do: first == second

  defp answer(zipped) do
     zipped
     |> Enum.filter(&do_tuple_elements_match?/1)
     |> Enum.map(fn {first, _second} -> first end)
     |> Enum.join()    
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