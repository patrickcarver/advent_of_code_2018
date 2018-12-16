defmodule Day12 do

  def run(limit) do
    pots = get_pots()
    notes = get_notes()

    generation(pots, notes, 1, limit)
  end

#  def generation(pots, _notes, gen_num, gen_limit) when gen_num > gen_limit do
#    pots
#    |> Enum.filter(fn {token, _index} -> token == "#" end)
#    |> Enum.reduce(0, fn {_token, value}, acc -> value + acc end)
#  end

  def generation(pots, _notes, 101, _gen_limit) do
   # pots

    start = (50_000_000_000 - 11)
    pots
    |> Enum.reduce({[], start}, fn {token, _}, {list, num} ->
      new_list = [{token, num} | list]
      new_num = num + 1
      {new_list, new_num}
    end)
    |> elem(0)
    |> Enum.filter(fn {token, _index} -> token == "#" end)
    |> Enum.map(fn {_token, index} -> index end)
    |> Enum.sum()
  end

  def generation(pots, notes, gen_num, gen_limit) do
    pots_to_scan = create_pots_to_scan(pots)
    start = 2
    finish = length(pots_to_scan) - 3

    new_pots = start..finish
                |> Enum.reduce([], fn i, acc ->
                  range = (i-2)..(i+2)
                  pattern = Enum.slice(pots_to_scan, range) |> Enum.map(fn {token, _} -> token end)
                  updated_token = Map.get(notes, pattern)
                  {_old, pot_index} = Enum.at(pots_to_scan, i)
                  [{updated_token, pot_index} | acc]
                end)
                |> Enum.drop_while(fn {token, _pot_index} -> token == "." end)
                |> Enum.reverse()
                |> Enum.drop_while(fn {token, _pot_index} -> token == "." end)

    {{_, min}, {_, max}} = new_pots |> Enum.min_max_by(fn {_, index} -> index end)
    IO.inspect "#{gen_num} #{min} #{max}"
    #string = new_pots |> Enum.map(fn {token, _index} -> token end) |> Enum.join("")
    #IO.inspect(string)

    generation(new_pots, notes, gen_num + 1, gen_limit)
  end

  def create_pots_to_scan(pots) do
    {{_, min}, {_, max}} = pots |> Enum.min_max_by(fn {_, index} -> index end)
    left = (min-4)..(min-1) |> Enum.map(fn index -> {".", index} end)
    right = (max+1)..(max+4) |> Enum.map(fn index -> {".", index} end)

    left ++ pots ++ right
  end

  def get_pots() do
    "#.#####.#.#.####.####.#.#...#.......##..##.#.#.#.###..#.....#.####..#.#######.#....####.#....##....#"
    |> String.codepoints()
    |> Enum.with_index()
  end

  def get_notes() do
    "input.txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.reduce(%{}, fn line, notes ->
      [pattern_string, result] = line |> String.trim_trailing() |> String.split(" => ")
      pattern = pattern_string |> String.codepoints()
      Map.put(notes, pattern, result)
    end)
  end
end
