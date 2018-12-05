defmodule Day05.Part2 do
  alias Day05.{FileLoader, Part1}

  def run(file_name) do
    file_name
    |> FileLoader.load()
    |> create_letter_list()
    |> go_thru_the_alphabet()
  end

  defp go_thru_the_alphabet(list) do
    generate_alphabet()
    |> Enum.map(fn letter ->
          list
          |> Enum.reject(fn element -> String.downcase(element) == letter end)
          |> Part1.total_remaining_units()
       end)
    |> Enum.min()
  end

  defp generate_alphabet() do
    for n <- ?a..?z, do: << n :: utf8 >>
  end

  defp create_letter_list(file_stream) do
    file_stream
    |> Enum.map(&String.trim_trailing/1)
    |> List.first()
    |> String.codepoints()
  end
end
