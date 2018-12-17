defmodule Day13.Part1 do
  alias FileLoader

  def run(file_name) do

    file_name
    |> process_input()
    |> tick_through()
  end

  def tick_through(%{rails: rails, carts: carts}, tick \\ 1) do
    sorted_carts = sort_carts(carts)

    results = sorted_carts
    |> Enum.reduce_while(%{remaining: tl(sorted_carts) , moved: %{}},
      fn { coord, {token, current_turn_option} }, acc ->
        new_coord = next_coord(token, coord)

        coords_to_check = Map.merge(acc.remaining |> Enum.into(%{}), acc.moved)

        if Map.has_key?(coords_to_check, new_coord) do
          {:halt, new_coord}
        else
          updated_cart = update_cart({token, current_turn_option}, rails[new_coord])
          updated_remaining = Map.delete(acc.remaining |> Enum.into(%{}), coord)
          updated_moved = Map.put(acc.moved, new_coord, updated_cart)

          {:cont, %{remaining: updated_remaining, moved: updated_moved}}
        end
      end)

    case results do
      %{moved: updated_carts} ->
        tick_through(%{rails: rails, carts: updated_carts}, tick + 1)
      coord ->
        {coord, tick}
    end
  end

  def update_cart({">", option}, "%"), do: {"v", option} # east going to south
  def update_cart({">", option}, "/"), do: {"^", option} # east going to north
  def update_cart({"<", option}, "%"), do: {"^", option} # west going to north
  def update_cart({"<", option}, "/"), do: {"v", option} # west going to south

  def update_cart({"^", option}, "/"), do: {">", option} # north going to east
  def update_cart({"^", option}, "%"), do: {"<", option} # north going to west
  def update_cart({"v", option}, "/"), do: {"<", option} # south going to east
  def update_cart({"v", option}, "%"), do: {">", option} # south going to west

  def update_cart({">", 0}, "+"), do: {"^", 1}
  def update_cart({">", 1}, "+"), do: {">", 2}
  def update_cart({">", 2}, "+"), do: {"v", 0}

  def update_cart({"<", 0}, "+"), do: {"v", 1}
  def update_cart({"<", 1}, "+"), do: {"<", 2}
  def update_cart({"<", 2}, "+"), do: {"^", 0}

  def update_cart({"^", 0}, "+"), do: {"<", 1}
  def update_cart({"^", 1}, "+"), do: {"^", 2}
  def update_cart({"^", 2}, "+"), do: {">", 0}

  def update_cart({"v", 0}, "+"), do: {">", 1}
  def update_cart({"v", 1}, "+"), do: {"v", 2}
  def update_cart({"v", 2}, "+"), do: {"<", 0}

  def update_cart({token, option}, _rail), do: {token, option} # rail is - or |

  def next_coord(">", {x, y}), do: {x + 1, y}
  def next_coord("<", {x, y}), do: {x - 1, y}
  def next_coord("v", {x, y}), do: {x, y + 1}
  def next_coord("^", {x, y}), do: {x, y - 1}

  def sort_carts(carts) do
    carts
    |> Enum.sort(fn {{first, _}, _}, {{second, _}, _} -> first <= second end)
    |> Enum.sort(fn {{_, first}, _}, {{_, second}, _} -> first <= second end)
  end

  def process_input(file_name) do
    file_name
    |> FileLoader.load()
    |> Enum.map(& &1 |> String.replace("\\", "%"))
    |> Enum.map(& &1 |> String.codepoints() |> Enum.with_index()) # x
    |> Enum.with_index() # y
    |> Enum.map(&create_row/1)
    |> Enum.reduce(&Map.merge/2)
    |> Enum.reject(fn {_k, v} -> v == " " end)
    |> Enum.reduce(%{rails: %{}, carts: %{}}, &process_cart/2)
  end

  def process_cart({coord, token}, acc) when token in ["^", "v"] do
    carts = Map.put(acc.carts, coord, {token, 0})
    rails = Map.put(acc.rails, coord, "|")
    %{ carts: carts, rails: rails }
  end

  def process_cart({coord, token}, acc) when token in ["<", ">"] do
    carts = Map.put(acc.carts, coord, {token, 0})
    rails = Map.put(acc.rails, coord, "-")
    %{ carts: carts, rails: rails }
  end

  def process_cart({coord, token}, acc) do
    rails = Map.put(acc.rails, coord, token)
    %{acc | rails: rails}
  end

  def create_row({list, y}) do
    list
    |> Enum.reduce(%{}, fn {token, x}, acc ->
        Map.put(acc, {x, y}, token)
    end)
  end
end
