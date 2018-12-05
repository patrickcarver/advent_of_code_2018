defmodule Day04.Part1.GuardRecordList do
  alias Day04.Part1.FileLoader

  def read(file) do
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
