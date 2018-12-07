defmodule Day07 do

  def run(part: part, mode: mode) do
    mode
    |> get_input_file_name()
    |> run_selected(part)
  end

  defp get_input_file_name(:prod), do: "input.txt"
  defp get_input_file_name(:test), do: "test.txt"
  defp get_input_file_name(_mode), do: {:error, :invalid_mode}

  defp run_selected({:error, :invalid_mode} = error, _part) do
    error
  end

  defp run_selected(input_file_name, 1) do
    Day07.Part1.run(input_file_name)
  end

  defp run_selected(input_file_name, 2) do
    Day07.Part2.run(input_file_name)
  end

  defp run_selected(_input_file_name, _invalid_part) do
    {:error, :invalid_part}
  end
end

