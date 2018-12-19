defmodule Day14 do
  def run(num_recipes) do
    limit = num_recipes + 10 + 1

    recipes = [3,7]
    elf_one_index = 0
    elf_two_index = 1

    {recipes, elf_one_index, elf_two_index}
    |> create_new_recipes()
    |> create_new_recipes()
    |> create_new_recipes()
    |> create_new_recipes()

  end

  def create_new_recipes({recipes, elf_one_index, elf_two_index}) do
    current1 = Enum.at(recipes, elf_one_index)
    current2 = Enum.at(recipes, elf_two_index)

    result = (current1 + current2) |> Integer.digits()
    new_recipes = recipes ++ result

    new_elf_one_index = rem((1 + current1), length(new_recipes)) + elf_one_index
    new_elf_two_index = rem((1 + current2), length(new_recipes)) + elf_two_index

    IO.inspect 1 + current1
    IO.inspect length(new_recipes)
    IO.inspect rem((1 + current1), length(new_recipes))
    IO.inspect elf_one_index
    IO.inspect "######"

    {new_recipes, new_elf_one_index, new_elf_two_index}
  end
end




# num_recipes
# current_recipes
# score_board

# first elf creates recipe
# second elf creates recipe
# add their scores together
# take that sum and break apart digits
# add digits to end of scoreboard
# move elves to new current recipe
  # 1 + score of current recipe
  # if that run out, they loop back to beginning
