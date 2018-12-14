defmodule Day11 do
  # 4842

  defmodule FuelCell do

    def create(x, y, grid_serial_number) do
      power_level = FuelCell.create_power_level({x, y}, grid_serial_number)

      %{
        x: x,
        y: y,
        power_level: power_level
      }
    end

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


  def run_live() do
    width = 300
    height = 300
    grid_serial_number = 4842
    run(width, height, grid_serial_number)
  end

  def run(width, height, grid_serial_number) do

    travel_grid(width-2, height-2, grid_serial_number)
  end

  def travel_grid(max_x, max_y, grid_serial_number) do
    # largest_total_power
    # coord_with_largest_total_power
    # coords

    1..max_y
    |> Enum.reduce(%{}, fn y, grid_result ->
      1..max_x
      |> Enum.reduce(%{}, fn x, row_result ->
        create_square(x, y, grid_serial_number)
      end)
      grid_result
    end)
  end

  def create_square(start_x, start_y, grid_serial_number) do
    for y <- start_y..(start_y+2), x <- start_x..(start_x+2) do
      FuelCell.create(x, y, grid_serial_number)
    end
  end
end
