defmodule Day05.Part2 do
  alias Day05.Units

  def run(file_name) do
    file_name
    |> Units.create()
    |> go_thru_the_alphabet()
  end

  defp go_thru_the_alphabet(list) do
    generate_alphabet()
    |> Enum.map(fn letter ->
          list
          |> Enum.reject(fn element -> String.downcase(element) == letter end)
          |> Units.total_after_all_reacted()
       end)
    |> Enum.min()
  end

  defp generate_alphabet() do
    for n <- ?a..?z, do: << n :: utf8 >>
  end
end
