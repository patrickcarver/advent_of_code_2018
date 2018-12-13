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


  end
end
