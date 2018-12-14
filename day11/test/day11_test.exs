defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  alias Day11
  alias Day11.FuelCell

  test "given coordinate {0,0} and grid_serial_number 4842"

  test "given coordinate {122,79} and grid_serial_number 57, power level should be -5" do
    actual = FuelCell.create_power_level({122, 79}, 57)
    expected = -5
    assert actual == expected
  end

  test "given coordinate {217,196} and grid_serial_number 39, power level should be 0" do
    actual = FuelCell.create_power_level({217, 196}, 39)
    expected = 0
    assert actual == expected
  end

  test "given coordinate {101,153} and grid_serial_number 71, power level should be 4" do
    actual = FuelCell.create_power_level({101, 153}, 71)
    expected = 4
    assert actual == expected
  end

  test "given coordinate {3,5} and grid_serial_number 8, power level should be 4" do
    actual = FuelCell.create_power_level({3, 5}, 8)
    expected = 4
    assert actual == expected
  end
end
