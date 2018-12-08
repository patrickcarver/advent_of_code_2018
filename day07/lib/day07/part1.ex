defmodule Day07.Part1 do
  alias Day07.FileLoader

  # ruthlessly and shamelessly stolen....er...inspired by the Ian S. Pringle's python version
  # https://github.com/pard68/aoc/commit/62b8fda1dfb7a8c31bc61f67e3e713292a9a07d7

  def run(file_name) do
    file_name |> parse_into_list() |> process()
  end

  def process(list, order \\ "")

  def process([], order) do
    order
  end

  def process(list, order) do
    letter = list |> get_current() |> List.first()
    new_list = list |> remove_pairs_starting_with(letter)
    letter_to_add = list |> get_letter_to_add(letter)

    process(new_list, order <> letter_to_add)
  end

  def get_letter_to_add(list, letter) when length(list) > 1 do
    letter
  end

  def get_letter_to_add(list, _letter) do
    list |> List.first() |> Enum.join("")
  end

  def remove_pairs_starting_with(list, letter) do
    list |> Enum.reject(fn [first, _] -> first == letter end)
  end

  def get_current(list) do
    first = list |> first_in_pairs
    last = list |> last_in_pairs

    (first -- last) |> Enum.sort()
  end

  def first_in_pairs(list) do
    list |> Enum.map(fn [first, _] -> first end) |> Enum.uniq
  end

  def last_in_pairs(list) do
    list |> Enum.map(fn [_, last] -> last end) |> Enum.uniq
  end

  def parse_into_list(file_name) do
    file_name
    |> FileLoader.load()
    |> Enum.map(&parse_into_letters/1)
  end

  def parse_into_letters(line) do
    line
    |> String.split(" ")
    |> Enum.filter(fn word -> String.length(word) == 1 end)
  end
end
