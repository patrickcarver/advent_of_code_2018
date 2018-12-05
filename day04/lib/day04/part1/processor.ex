defmodule Day04.Part1.Processor do
  defp update_records(records, current_record) do
    unless current_record == nil do
      %{id: id, times: times} = current_record
      # create list of minutes using ranges
      new_times = Enum.map(times, fn {sleep, awake} -> sleep..(awake-1) |> Enum.to_list() end) |> List.flatten()
      new_time_totals = Enum.sum(new_times)

      Map.update(records, id, {[], 0}, fn {current_times, total} -> { [new_times | current_times], total + new_time_totals} end);
    else
      records
    end
  end

  def process(list, current_record \\ nil, records \\ %{})

  def process([{_date_time, {:guard, new_id}} | tail], current_record, records) do
    updated_records = update_records(records, current_record)
    new_record = %{id: new_id, previous_event: nil, times: []}

    process(tail, new_record, updated_records)
  end

  def process([{date_time, "falls asleep" = event} | tail], current_record, records) do
    new_times = [{date_time.minute, nil}| current_record.times]
    updated_record = %{current_record | previous_event: event, times: new_times}

    process(tail, updated_record, records)
  end

  def process([{date_time, "wakes up" = event} | tail], current_record, records) do
    [{start, nil} | times] = current_record.times
    new_times = [{start, date_time.minute} | times]
    updated_record = %{current_record | previous_event: event, times: new_times}

    process(tail, updated_record, records)
  end

  def process([], _current_record, records) do
    records
  end

  def process(_, _, _) do
    {:error, "no match for opts"}
  end
end
