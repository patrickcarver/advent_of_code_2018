defmodule Day16.Part1 do
  alias FileLoader

  def run(file_name) do
    file_name
    |> load_samples()
  end

  def load_samples(file_name) do
    file_name
    |> FileLoader.load()
    |> Enum.chunk_every(3,4)
    |> Enum.map(&parse_sample/1)
  end

  def parse_sample([before_txt, instruction_txt, after_txt]) do
    before_list = parse_register_text(before_txt)
    after_list = parse_register_text(after_txt)
    instruction_list = parse_instruction_txt(instruction_txt)

    %{
      before: before_list,
      after: after_list,
      instruction: instruction_list
    }
  end

  def parse_instruction_txt(text) do
    text
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  def parse_register_text(text) do
    text
    |> String.split(": ")
    |> List.last()
    |> Code.eval_string()
    |> elem(0)
  end
end
