defmodule Day04.Part2.Answer do
  alias Day04.Part1.Answer, as: Part1Answer

  def calculate(records) do
    records
    |> Enum.map(fn record ->
      record
      |> Part1Answer.remove_total()
      |> Part1Answer.collapse_tuple()
      |> Part1Answer.create_minute_list()
      |> Part1Answer.count_minute_occurances()
      |> find_largest_occurance_count()
    end)
    |> find_most_often_minute()
    |> remove_occurance_count()
    |> Part1Answer.multiply_id_and_minute()
  end

  defp remove_occurance_count({id, minute, _}) do
    {id, minute}
  end

  defp find_most_often_minute(records) do
    Enum.sort(records, fn first, second ->
      {_, _, first_count} = first
      {_, _, second_count} = second

      first_count >= second_count
    end) |> List.first
  end

  defp find_largest_occurance_count({id, counts}) do
    {found_minute, found_count} =
      Enum.reduce(counts, {0, 0}, fn current, largest ->
        {_, current_count} = current
        {_, largest_count} = largest

        case current_count >= largest_count do
          true -> current
          false -> largest
        end
      end)

    {id, found_minute, found_count}
  end
end
