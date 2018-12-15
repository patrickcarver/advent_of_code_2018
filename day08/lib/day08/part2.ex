defmodule Day08.Part2 do
  alias FileLoader

  def run(file_name) do
    create_tree(file_name)
    |> find_value()
  end

  def create_tree(file_name) do
    { root, [] } =
      file_name
      |> get_nums()
      |> create_node()
    root
  end

  def create_node([num_of_children, num_of_metadata | rest]) do
    { children, new_rest } = create_children(num_of_children, rest, [])
    { metadata, new_new_rest } = Enum.split(new_rest, num_of_metadata)
    { { children, metadata }, new_new_rest }
  end

  def create_children(0, rest, acc) do
    { Enum.reverse(acc), rest }
  end

  def create_children(count, rest, acc) do
   { node, new_rest } = create_node(rest)
   create_children(count - 1, new_rest, [node | acc])
  end

  def find_value({[], metadata}) do
    Enum.sum(metadata)
  end

  def find_value({children, metadata}) do
    indexed_sums = Enum.map(children, &find_value/1)

    sums =
      for index <- metadata,
        sum = Enum.at(indexed_sums, index - 1),
        do: sum

    Enum.sum(sums)
  end

  def get_nums(file_name) do
    file_name
    |> FileLoader.load()
    |> List.first()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end
end




