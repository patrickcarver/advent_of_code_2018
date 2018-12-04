defmodule Day04 do

  defmodule FileLoader do
    def load(file_name) do
      file_name
      |> Path.expand(__DIR__)
      |> File.stream!()
    end
  end

  defmodule Part1 do
    # year-month-day hour:minute
    # guard id'ed "begins shift"
    # only midnight-hour minutes are relevant for asleep/awake times
      # guards might start duty on non-midnight hours
    # guards count as asleep the minute they fall asleep
    # guards count as awake the minute they wake up.
    # CHOOSE BEST GUARD / MINUTE combination
    # Strategy 1:
    #   a) Find guard with most sleep minutes
    #   b) what minute does that guard sleep the most?
    # ALSO: our input isn't in order. we need to sort that first



    def run() do
      "../txt/input.txt"
      |> do_run()
    end

    def do_run(file) do
      sorted_list = sort_list(file)

      process(sorted_list, nil, %{})
    end

    defp update_records(records, current_record) do
      unless current_record == nil do
        %{id: id, times: times} = current_record
        # create list of minutes using ranges
        new_times = Enum.map(times, fn {sleep, awake} -> sleep..(awake-1) |> Enum.to_list() end) |> List.flatten()
        new_time_totals = Enum.sum(new_times)

        Map.update(records, id, {[], 0}, fn {current_times, total} -> { [new_times | current_times] |> List.flatten, total + new_time_totals} end);
      else
        records
      end
    end

    defp process([{_date_time, {:guard, new_id}} | tail], current_record, records) do
      updated_records = update_records(records, current_record)

      new_record = %{id: new_id, previous_event: nil, times: []}

      process(tail, new_record, updated_records)
    end

    defp process([{date_time, "falls asleep" = event} | tail], current_record, records) do
      new_times = [{date_time.minute, nil}| current_record.times]
      updated_record = %{current_record | previous_event: event, times: new_times}

      process(tail, updated_record, records)
    end

    defp process([{date_time, "wakes up" = event} | tail], current_record, records) do
      [{start, nil} | times] = current_record.times
      new_times = [{start, date_time.minute} | times]
      updated_record = %{current_record | previous_event: event, times: new_times}

      process(tail, updated_record, records)
    end

    defp process([], _current_record, records) do
      target = records
                |> Enum.reduce(%{id: nil, times: [], total: 0}, fn {id, {times, total}}, acc ->
                      if total > acc.total do
                        %{id: id, times: times, total: total}
                      else
                        acc
                      end
                  end)

      %{id: id, times: times} = target

      most_common_minute = find_most_common_minute(times)

      id + most_common_minute
    end

    defp process(_, _, _) do
      {:error, "no match for opts"}
    end

    defp find_most_common_minute(times) do
      Enum.reduce(times, %{}, fn time, acc ->
        Map.update(acc, time, 0, &(&1 + 1))
      end) |> Enum.sort(fn {_, first}, {_, second} -> first >= second end) |> List.first |> elem(0)

    end


    defp sort_list(file) do
      file
      |> FileLoader.load()
      |> Enum.map(&parse_entry/1)
      |> Enum.sort(&sort_naive_date_time/2)
    end

    defp parse_entry(line) do
      line
      |> String.trim_trailing()
      |> remove_brackets()
      |> List.to_tuple
      |> parse_tuple()
    end

    defp parse_tuple({date, status}) do
      parsed_date = parse_date(date)
      parsed_status = parse_status(status)
      { parsed_date, parsed_status }
    end

    defp parse_date(date) do
      NaiveDateTime.from_iso8601(date <> ":00") |> elem(1)
    end

    defp parse_status(status) do
      list = String.split(status, " ")

      if List.first(list) == "Guard" do
        id = Enum.at(list, 1) |> String.replace("#", "") |> String.to_integer()
        {:guard, id}
      else
        status
      end
    end

    defp sort_naive_date_time({first, _}, {second, _}) do
      NaiveDateTime.compare(first, second) == :lt
    end

    defp remove_brackets(line) do
      line
      |> String.replace("[", "")
      |> String.split("] ")
    end
  end


end
