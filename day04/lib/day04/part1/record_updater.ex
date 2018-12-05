defmodule Day04.Part1.RecordUpdater do
  def update(records, nil) do
    records
  end

  def update(records, %{id: id, times: times}) do
    additional_time = time_to_add(times)

    # todo: get Map.update to work right
    if Map.has_key?(records, id) do
      %{times: existing_times, total: total} = Map.get(records, id)
      updated_times = times ++ existing_times
      updated_total = total + additional_time
      Map.put(records, id, %{times: updated_times, total: updated_total})
    else
      Map.put(records, id, %{times: times, total: additional_time })
    end
  end

  defp time_to_add(times) do
    Enum.reduce(times, 0, fn {asleep_minute, awake_minute}, acc ->
      acc + (awake_minute - asleep_minute)
    end)
  end
end
