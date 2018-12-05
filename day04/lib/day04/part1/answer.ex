defmodule Day04.Part1.Answer do
  def calculate(records) do
    records
    |> find_record_with_largest_total()
    |> remove_total()
    |> collapse_tuple()
    |> create_minute_list()
    |> count_minute_occurances()
    |> find_largest_occurance_count()
    |> multiple_id_and_minute()
  end

  defp multiple_id_and_minute({id, count}) do
    id * count
  end

  defp find_largest_occurance_count({id, counts}) do
    minute = Enum.reduce(counts, {0, 0}, fn current, largest ->
      {_, current_count} = current
      {_, largest_count} = largest

      case current_count >= largest_count do
        true -> current
        false -> largest
      end
    end) |> elem(0)

    {id, minute}
  end

  defp count_minute_occurances({id, range}) do
    counts = Enum.reduce(range, %{}, fn minute, acc ->
      Map.update(acc, minute, 1, &(&1 + 1))
    end)

    {id, counts}
  end

  defp create_minute_list({id, times}) do
    ranges =
      times
      |> Enum.map(fn {asleep_minute, awake_minute} ->
           asleep_minute..(awake_minute-1) |> Enum.to_list()
         end)
      |> List.flatten()

    {id, ranges}
  end

  defp collapse_tuple({id, %{times: times}}) do
    {id, times}
  end

  defp remove_total(record) do
    {id, %{times: times}} = record
    {id, %{times: times}}
  end

  defp find_record_with_largest_total(records) do
    Enum.reduce(records, fn record, largest ->
      record_total = record |> elem(1) |> Map.get(:total)
      largest_total = largest |> elem(1) |> Map.get(:total)

      if record_total >= largest_total do
        record
      else
        largest
      end
    end)
  end
end
