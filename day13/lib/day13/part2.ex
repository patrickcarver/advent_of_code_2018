defmodule Day13.Part2 do
  alias FileLoader

  def run(file_name) do

    file_name
    |> process_input()
    |> tick_through()
  end




  def update_carts([], moved, _rails) do
    moved
  end

  def update_carts(unmoved, moved, rails) do
    [{ coord, {token, current_turn_option} } | rest] = (unmoved |> Enum.into([]))

    new_coord = next_coord(token, coord)


    updated_rest = if Map.has_key?(rest |> Enum.into(%{}), new_coord) do
       Map.delete(rest |> Enum.into(%{}), new_coord)
    else
      rest
    end

    updated_moved = if Map.has_key?(moved, new_coord) do
      Map.delete(moved, new_coord)
    else
      updated_cart = update_cart({token, current_turn_option}, rails[new_coord])
      Map.put(moved, new_coord, updated_cart)
    end


    update_carts(updated_rest, updated_moved, rails)
  end

  def tick_through(data, tick \\ 1)



  def tick_through(%{rails: rails, carts: carts}, tick) do
    sorted_carts = sort_carts(carts)

    updated_carts = update_carts(sorted_carts, %{}, rails)

    if Enum.count(updated_carts) == 1 do
      updated_carts
    else
      tick_through(%{rails: rails, carts: updated_carts}, tick + 1)
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

