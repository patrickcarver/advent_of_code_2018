defmodule Day14 do
  defmodule CircularList do
    alias CircularList

    defstruct [
      items: %{},
      size: 0,
      last_item: nil,
      elf_one_index: 0,
      elf_two_index: 1
    ]

    def add_recipe(%CircularList{size: 0} = circular_list, recipe) do
      item = %{value: recipe, next: 0}
      updated_items = Map.put(circular_list.items, circular_list.size, item)

      %CircularList{ circular_list |
        items: updated_items,
        last_item: item,
        size: circular_list.size + 1
      }
    end

    def add_recipe(circular_list, recipe) do
      new_item = %{value: recipe, next: 0}
      updated_last_item = Map.put(circular_list.last_item, :next, circular_list.size)

      updated_items =
        circular_list.items
        |> Map.put(circular_list.size, new_item)
        |> Map.put(circular_list.size-1, updated_last_item)

      %CircularList{
        items: updated_items,
        last_item: new_item,
        size: circular_list.size+1
      }
    end

    def new([first, second]) do
      %CircularList{}
      |> add_recipe(first)
      |> add_recipe(second)
    end

    def generate_new_recipes(circular_list) do

      %{value: elf_one_value} = Map.fetch!(circular_list.items, circular_list.elf_one_index)
      %{value: elf_two_value} = Map.fetch!(circular_list.items, circular_list.elf_two_index)
      new_recipes = (elf_one_value + elf_two_value) |> Integer.digits()

      new_circular_list =
        Enum.reduce(new_recipes, circular_list, fn recipe, acc ->
          CircularList.add_recipe(acc, recipe)
        end)

      # update elf indices

      updated_elf_one_index = rem((circular_list.elf_one_index + (1 + elf_one_value)), new_circular_list.size)
      updated_elf_two_index = rem((circular_list.elf_two_index + (1 + elf_two_value)), new_circular_list.size)

      %CircularList{
        new_circular_list |
        elf_one_index: updated_elf_one_index,
        elf_two_index: updated_elf_two_index
      }
    end
  end

  defmodule Part1 do
    def loop(%CircularList{size: size} = circular_list, limit) when size > limit do
      (size-11)..(size-2)
      |> Enum.map(fn index -> circular_list.items[index] end)
      |> Enum.map(fn %{value: value} -> value end)
      |> Enum.join()
    end

    def loop(%CircularList{size: size} = circular_list, limit) when size == limit do
      (size-10)..(size-1)
      |> Enum.map(fn index -> circular_list.items[index] end)
      |> Enum.map(fn %{value: value} -> value end)
      |> Enum.join()
    end

    def loop(circular_list, limit) do
      new_circular_list = circular_list |> CircularList.generate_new_recipes()
      loop(new_circular_list, limit)
    end
  end

  defmodule Part2 do
    def grab_from_range(%CircularList{size: size, items: items}, front, back) do
      (size-front)..(size-back)
      |> Enum.map(fn index -> items[index] end)
      |> Enum.map(fn %{value: value} -> value end)
      |> Enum.join()
    end

    def loop(%CircularList{size: size} = circular_list, target, length_to_check)
    when size <= length_to_check do
      new_circular_list = circular_list |> CircularList.generate_new_recipes()
      loop(new_circular_list, target, length_to_check)
    end

    def loop(circular_list, target, length_to_check) do
      new_circular_list = circular_list |> CircularList.generate_new_recipes()

      candidate = grab_from_range(new_circular_list, length_to_check, 1)

      if String.contains?(candidate, target) do
        new_circular_list.size - length_to_check
      else
        loop(new_circular_list, target, length_to_check)
      end

    end
  end

  def run_part1(input) do
    limit = input + 10
    circular_list = CircularList.new([3,7])
    Part1.loop(circular_list, limit)
  end

  def run_part2(input) do
    circular_list = CircularList.new([3,7])
    length_to_check = String.length(input)
    Part2.loop(circular_list, input, length_to_check)
  end
end
