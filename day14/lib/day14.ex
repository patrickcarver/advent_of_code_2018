defmodule Day14 do
  def run(num_recipes) do
    limit = num_recipes + 10

    create_recipes({[3,7], 0, 1}, limit)
    |> Enum.take(limit)
    |> Enum.take(-10)
    |> Enum.join("")
   # |> Enum.reverse()
   # |> Enum.join("")


  end

  def create_recipes({recipes, _elf_one_index, _elf_two_index}, limit) when length(recipes) >= limit do
    recipes
  end

  def create_recipes({recipes, elf_one_index, elf_two_index}, limit) do
    elf_one_current_recipe = Enum.at(recipes, elf_one_index)
    elf_two_current_recipe = Enum.at(recipes, elf_two_index)

    recipes_to_add = (elf_one_current_recipe + elf_two_current_recipe) |> Integer.digits()
    updated_recipes = recipes ++ recipes_to_add

    len = length(updated_recipes)
    IO.inspect len

    updated_elf_one_index = rem((elf_one_index + (1 + elf_one_current_recipe)), len)
    updated_elf_two_index = rem((elf_two_index + (1 + elf_two_current_recipe)), len)

    create_recipes({updated_recipes, updated_elf_one_index, updated_elf_two_index}, limit)

  end

end
