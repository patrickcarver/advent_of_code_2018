defmodule Day08.Part1 do
  alias FileLoader

  defmodule Node do
    defstruct [
      total_children: nil,
      total_entries: nil,
      children: [],
      entries: []
    ]
  end

  def run(file_name) do
    nums = get_nums(file_name)

   # create_node(nil, nums)
  end

  def create_tree(node, []) do
    node
  end



  def create_tree(parent, nums) do
    [total_children, total_entries | rest] = nums

    node = %Node{total_children: total_children, total_entries: total_entries}

    if total_children == 0 do
      {entries, new_rest} = Enum.split(rest, total_entries)
      updated_node = %Node{node | entries: entries}
      create_tree(updated_node, new_rest)
    else
      handle_children(node, total_children, rest)
    end
  end

  def handle_children(parent, 0, nums) do
    create_tree(parent, nums)
  end

  def handle_children(parent, count, nums) do

    handle_children(parent, count -1, )
  end

  def get_nums(file_name) do
    file_name
    |> FileLoader.load()
    |> List.first()
    |> String.split(" ")
  end
end



