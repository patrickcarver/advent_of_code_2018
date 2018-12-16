defmodule Part2 do

  def run() do
    pots = get_pots()
    notes = get_notes()

    generation(pots, notes, 1, 20)
  end

  def generation(pots, _notes, gen_num, gen_limit) when gen_num > gen_limit do
    pots
    |> Enum.sum()
  end

  def generation(pots, notes, gen_num, gen_limit) do
    new_pots = pots
    |> Enum.reduce(MapSet.new(), fn pot_index, acc ->
        pattern = (pot_index - 2)..(pot_index + 2)
                |> Enum.map(fn i -> if MapSet.member?(pots, i), do: "#", else: "." end)
        IO.inspect(pattern)

        if notes[pattern] == "#", do: MapSet.put(acc, pot_index), else: acc
      end)

    IO.inspect(new_pots)

    generation(new_pots, notes, gen_num + 1, gen_limit)
  end



  def get_pots() do
    "#.#####.#.#.####.####.#.#...#.......##..##.#.#.#.###..#.....#.####..#.#######.#....####.#....##....#"
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(),
      fn
        {"#", index}, set -> MapSet.put(set, index)
        {".", _index}, set -> set
      end)
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
