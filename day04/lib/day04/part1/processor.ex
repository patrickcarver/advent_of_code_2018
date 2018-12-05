defmodule Day04.Part1.Processor do

  alias Day04.Part1.RecordUpdater

  def process(list, current_record \\ nil, records \\ %{})

  def process([{_date_time, {:guard, id}} | tail], current_record, records) do
    # we are starting a new user id
    # we need to store times into records by user id
    # add new key if user does not exist and set value to times
    # if key exists add times to existing times
    updated_records = RecordUpdater.update(records, current_record)

    new_record = %{id: id, times: [], previous_event: nil}

    process(tail, new_record, updated_records)
  end

  def process([{date_time, "falls asleep"} | tail], current_record, records) do
    new_times = [{date_time.minute, nil} | current_record.times]
    updated_record = %{current_record | times: new_times}

    process(tail, updated_record, records)
  end

  def process([{date_time, "wakes up"} | tail], current_record, records) do
    [{start_minute, _ } | rest] = current_record.times
    new_times = [{start_minute, date_time.minute} | rest]
    updated_record = %{current_record | times: new_times}

    process(tail, updated_record, records)
  end

  def process([], current_record, records) do
    RecordUpdater.update(records, current_record)
  end

  def process(_, _, _) do
    {:error, "no match for opts"}
  end
end
