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
      |> process()
    end

    defp process({date, info}) do
      parsed_date = parse_date(date)
      { parsed_date, info }
    end

    defp sort_naive_date_time({first, _}, {second, _}) do
      NaiveDateTime.compare(first, second) == :lt
    end

    defp parse_date(date) do
      NaiveDateTime.from_iso8601(date <> ":00") |> elem(1)
    end

    defp remove_brackets(line) do
      line
      |> String.replace("[", "")
      |> String.split("] ")
    end
  end


end
