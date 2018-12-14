defmodule Day11 do
  # 4842

  defmodule FuelCell do
    def create_power_level({x, y}, grid_serial_number) do
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

#  def find_fuel_cell(grid, square_size) do
#    offset = square_size - 1

#    grid
#    |> Enum.reduce(%{coord: nil, power_level: 0}, fn y, y_acc ->
#      x_largest =
#    end)
#  end




  def run_part1() do
    grid_length = 300
    square_size = 3
    grid_serial_number = 4842

    grid_length
    |> create_grid(grid_serial_number)
    |> find_largest(grid_length, square_size)
  end

  def run_part2() do
  #  grid_length = 300
  #  grid_serial_number = 4842


  end

  def create_grid(size, grid_serial_number) do
    for y <- 1..size do
      1..size
      |> Enum.map(fn x ->
         power_level =  FuelCell.create_power_level({x,y}, grid_serial_number)
         %{coord: {x, y}, power_level: power_level}
      end)
    end
    |> List.flatten()
    |> Enum.reduce(%{}, fn item, acc ->
         Map.put(acc, item.coord, item.power_level)
    end)
  end

  def find_largest(grid, grid_dimension, square_size) do
    offset = square_size - 1

    max_x = grid_dimension - offset
    max_y = grid_dimension - offset

    1..max_y
    |> Enum.reduce(%{coord: nil, power_level: 0}, fn y, y_acc ->
          x_largest = 1..max_x
                      |> Enum.reduce(%{coord: nil, power_level: 0}, fn x, x_acc ->
                            square_power_level = get_square_power_level(grid, x, x+offset, y, y+offset)

                            if x_acc.power_level < square_power_level do
                              %{coord: {x, y}, power_level: square_power_level}
                            else
                              x_acc
                            end
                         end)

          if y_acc.power_level < x_largest.power_level do
            x_largest
          else
            y_acc
          end
       end)
    |> Map.put(:square_size, square_size)
  end

  def get_square_power_level(grid, start_x, end_x, start_y, end_y) do
    for y <- start_y..end_y, x <- start_x..end_x do
      grid[{x, y}]
    end
    |> Enum.sum()
  end

  def create_power_levels(start_x, end_x, start_y, end_y, grid_serial_number) do
    for y <- start_y..end_y, x <- start_x..end_x do
      FuelCell.create_power_level({x, y}, grid_serial_number)
    end
  end
end
