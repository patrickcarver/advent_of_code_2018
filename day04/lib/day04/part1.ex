
defmodule Day04.Part1 do
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

  alias Day04.Part1.{GuardRecordList, Processor}

  def run(file) do
    file
    |> GuardRecordList.read()
    |> Processor.process()
    |> calculate_answer()
  end

  defp calculate_answer(records) do
    IO.inspect records
    target = records
              |> Enum.reduce(%{id: nil, times: [], total: 0}, fn {id, {times, total}}, acc ->
                    if total > acc.total do
                      %{id: id, times: times, total: total}
                    else
                      acc
                    end
                end)
    IO.inspect target
    %{id: id, times: times} = target

    most_common_minute = find_most_common_minute(times)
    IO.inspect(most_common_minute, charlists: :as_lists)
    id * most_common_minute
  end

  defp find_most_common_minute(times) do
    times
    |> Enum.reduce(%{}, fn time, acc -> Map.update(acc, time, 0, &(&1 + 1)) end)
    |> Enum.sort(fn {_, first}, {_, second} -> first >= second end)
    |> List.first
    |> elem(0)

  end
end
