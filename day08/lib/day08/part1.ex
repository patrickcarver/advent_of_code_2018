defmodule Day08.Part1 do
  alias FileLoader

  # based on Jose Valim's walkthrough found at https://www.twitch.tv/videos/346803810

  def run(file_name) do
    create_tree(file_name)
    |> sum_metadata()
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

  def sum_metadata(tree) do
    sum_metadata(tree, 0)
  end

  def sum_metadata({children, metadata}, acc) do
    sum_children = Enum.reduce(children, 0, &sum_metadata/2)
    sum = Enum.sum(metadata)
    sum_children + sum + acc
  end

  def get_nums(file_name) do
    file_name
    |> FileLoader.load()
    |> List.first()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end
end



