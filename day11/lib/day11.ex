defmodule Day11 do
  # 4842

  defmodule FuelCell do
    def get_power_level({x, y}, grid_serial_number) do
      rack_id = x + 10

      rack_id
      |> Kernel.*(y)
      |> Kernel.+(grid_serial_number)
      |> Kernel.*(rack_id)
      |> get_hundreds_digit()
      |> Kernel.-(5)
    end

    defp get_hundreds_digit(number) do
      digit = number |> Integer.digits() |> Enum.at(-3)
      if digit == nil, do: 0, else: digit
    end
  end




  def run_part1() do
    grid_length = 300
    square_size = 3
    grid_serial_number = 4842

    travel_grid(grid_length, square_size, grid_serial_number)
  end

  def run_part2() do
    grid_length = 300
    grid_serial_number = 4842

    find_largest_amongst_squares(grid_length, grid_serial_number)
  end

  def find_largest_amongst_squares(grid_length, grid_serial_number) do
    max_square_size = grid_length

    1..max_square_size
    |> Enum.reduce(%{coord: nil, power_level: 0, square_size: nil},  fn square_size, acc ->
      current = travel_grid(grid_length, square_size, grid_serial_number)

      result = if acc.power_level < current.power_level do
        %{coord: current.coord, power_level: current.power_level, square_size: square_size}
      else
        acc
      end
      IO.inspect result
      result
    end)
  end

  def travel_grid(grid_length, square_size, grid_serial_number) do
    offset = square_size - 1

    max_x = grid_length - offset
    max_y = grid_length - offset

    1..max_y
    |> Enum.reduce(%{coord: {1, 1}, power_level: 0}, fn y, y_acc ->
      x_largest = 1..max_x
                  |> Enum.reduce(%{coord: {1, y}, power_level: 0}, fn x, x_acc ->
                    current_power = create_power_levels(x, x+offset, y, y+offset, grid_serial_number) |> Enum.sum()

                    if x_acc.power_level < current_power do
                      %{coord: {x, y}, power_level: current_power}
                    else
                      x_acc
                    end
                  end)

      if y_acc.power_level < x_largest.power_level do
        %{coord: x_largest.coord, power_level: x_largest.power_level}
      else
        y_acc
      end

    end)
    |> Map.put(:square_size, square_size)
  end

  def create_power_levels(start_x, end_x, start_y, end_y, grid_serial_number) do
    for y <- start_y..end_y, x <- start_x..end_x do
      FuelCell.get_power_level({x, y}, grid_serial_number)
    end
  end
end
