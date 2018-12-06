defmodule Day05.Part1 do
  alias Day05.Units

  def run(file_name) do
    file_name
    |> Units.create()
    |> Units.total_after_all_reacted()
  end
end
