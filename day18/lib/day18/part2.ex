defmodule Day18.Part2 do
  alias FileLoader

  def run(file_name) do
    file_name
    |> create_lumber_area()
    |> pass_minute(1, 20)
  end

  def scan_neighbors(lumber_area, {x, y}) do
    [
      lumber_area[{x - 1, y - 1}],
      lumber_area[{x,     y - 1}],
      lumber_area[{x + 1, y - 1}],
      lumber_area[{x - 1, y    }],
      lumber_area[{x + 1, y    }],
      lumber_area[{x - 1, y + 1}],
      lumber_area[{x,     y + 1}],
      lumber_area[{x + 1, y + 1}]
    ]
  end

  def has_three_or_more_trees?(neighborhood) do
    neighborhood
    |> Enum.count(fn neighbor -> neighbor == "|" end)
    |> Kernel.>=(3)
  end

  def change_open_acre_to_trees(true), do: "|"
  def change_open_acre_to_trees(false), do: "."

  def update_open_acre(lumber_area, {x,y}) do
    token = lumber_area
            |> scan_neighbors({x, y})
            |> has_three_or_more_trees?()
            |> change_open_acre_to_trees()

    {{x, y}, token}
  end

  def has_three_or_more_lumberyards?(neighborhood) do
    neighborhood
    |> Enum.count(fn neighbor -> neighbor == "#" end)
    |> Kernel.>=(3)
  end

  def change_tree_acre_to_lumberyard(true), do: "#"
  def change_tree_acre_to_lumberyard(false), do: "|"

  def update_tree_acre(lumber_area, {x,y}) do
    token = lumber_area
            |> scan_neighbors({x,y})
            |> has_three_or_more_lumberyards?()
            |> change_tree_acre_to_lumberyard()

    {{x,y}, token}
  end

  def keep_lumberyard(true), do: "#"
  def keep_lumberyard(false), do: "."

  def has_one_or_more_tree_and_lumberyard?(neighborhood) do
    tree_count = neighborhood |> Enum.count(fn neighbor -> neighbor == "|" end)
    lumberyard_count = neighborhood |> Enum.count(fn neighbor -> neighbor == "#" end)

    tree_count >= 1 && lumberyard_count >= 1
  end

  def update_lumberyard_acre(lumber_area, {x, y}) do
    token = lumber_area
            |> scan_neighbors({x, y})
            |> has_one_or_more_tree_and_lumberyard?()
            |> keep_lumberyard()

    {{x,y}, token}
  end

  def calculate_resource_value(lumber_area) do
    tree_acre_count = lumber_area |> Enum.count(fn {_coord, token} -> token == "|" end)
    lumberyard_acre_count = lumber_area |> Enum.count(fn {_coord, token} -> token == "#" end)
    IO.inspect {tree_acre_count, lumberyard_acre_count}
    tree_acre_count * lumberyard_acre_count
  end

  def transform_for_writing(lumber_area) do
    lumber_area
    |> Enum.sort(fn {{first, _}, _}, {{second, _}, _} -> first <= second end)
    |> Enum.sort(fn {{_, first}, _}, {{_, second}, _} -> first <= second end)
    |> Enum.group_by(fn {{_x,y}, _token} -> y end, fn {{_x, _y}, token} -> token end)
    |> Enum.map(fn {_x, row} -> Enum.join(row, "") end)
    |> Enum.join("\n")
  end

  def write_to_file(string_to_write) do
    "../../txt/output.txt"
    |> Path.expand(__DIR__)
    |> File.write!(string_to_write)
  end

  def pass_minute(prev_lumber_area, minute, limit) when minute > limit do
    prev_lumber_area |> transform_for_writing |> write_to_file

    prev_lumber_area |> calculate_resource_value()
  end

  def pass_minute(prev_lumber_area, minute, limit) do

    new_lumber_area =
      Enum.map(prev_lumber_area,
        fn
          {{x, y}, "."} -> update_open_acre(prev_lumber_area, {x, y})
          {{x, y}, "|"} -> update_tree_acre(prev_lumber_area, {x, y})
          {{x, y}, "#"} -> update_lumberyard_acre(prev_lumber_area, {x, y})
        end)
      |> Enum.into(%{})

    IO.inspect minute
    calculate_resource_value(new_lumber_area)

    pass_minute(new_lumber_area, minute + 1, limit)
  end




  def create_lumber_area(file_name) do
    file_name
    |> FileLoader.load()
    |> Enum.map(fn line -> line |> String.graphemes() |> Enum.with_index() end)
    |> Enum.with_index() # y
    |> Enum.map(&create_row/1)
    |> Enum.reduce(&Map.merge/2)
  end

  def create_row({list, y}) do
    list
    |> Enum.reduce(%{}, fn {token, x}, acc ->
        Map.put(acc, {x, y}, token)
    end)
  end
end
