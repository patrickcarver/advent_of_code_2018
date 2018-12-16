defmodule Day14 do
  def run(num_recipes) do
    limit = num_recipes + 10 + 1


  end


end

score_board = [3, 7]

current_index_elf_one = 0
current_index_elf_two = 1

recipe1 = Enum.at(score_board, current_index_elf_one)
recipe2 = Enum.at(score_board, current_index_elf_two)

new_scores = recipe1 |> Kernel.+(recipe2) |> Integer.digits()

new_score_board = score_board ++ new_scores

places_to_move_for_elf_one = current_index_elf_one + 1
places_to_move_for_elf_two = current_index_elf_two + 1

score_board_length = new_score_board |> length

new_current_index_elf_one =


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
