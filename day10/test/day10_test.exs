defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  alias Day10.Part1

  setup_all do
    initial_points = [
      %{position: {0,0}, velocity: {3,0}},
      %{position: {5,5}, velocity: {-4, 4}},
      %{position: {4,-3}, velocity: {1,-2}},
      %{position: {-2,5}, velocity: {-2, -5}},
    ]

    points_after_1_second = [
      %{position: {3,0}, velocity: {3,0}},
      %{position: {1,9}, velocity: {-4, 4}},
      %{position: {5,-5}, velocity: {1,-2}},
      %{position: {-4,0}, velocity: {-2, -5}},
    ]

    {:ok,
      initial_points: initial_points,
      points_after_1_second: points_after_1_second
    }
  end

 # test "translate initial points for display", context do
 #   actual = context[:initial_points]
 #   |> Part1.translate_points_for_display()

 #   assert actual == expected
 # end




#  test "current y is bigger than prev" do

#  end

#  test "current y is smaller than prev" do

#  end
  test "current biggest x is greater than prev biggest x, so it is not inside" do
    prev = %{
      smallest_x: -10,
      smallest_y: -10,
      biggest_x: 10,
      biggest_y: 10
    }

    current = %{
      smallest_x: -5,
      smallest_y: -5,
      biggest_x: 15,
      biggest_y: 5
    }

    actual = current |> Part1.is_not_inside_of(prev)

    assert actual == true
  end

test "current smallest x is less than prev smallest x, so it is not inside" do
  prev = %{
    smallest_x: -10,
    smallest_y: -10,
    biggest_x: 10,
    biggest_y: 10
  }

  current = %{
    smallest_x: -15,
    smallest_y: -5,
    biggest_x: 5,
    biggest_y: 5
  }

  actual = current |> Part1.is_not_inside_of(prev)

  assert actual == true
end


test "current smallest y is less than prev smallest y, so it is not inside" do
  prev = %{
    smallest_x: -10,
    smallest_y: -10,
    biggest_x: 10,
    biggest_y: 10
  }

  current = %{
    smallest_x: -5,
    smallest_y: -15,
    biggest_x: 5,
    biggest_y: 5
  }

  actual = current |> Part1.is_not_inside_of(prev)

  assert actual == true
end

  test "current biggest y is greater than prev biggest y, so it is not inside" do
    prev = %{
      smallest_x: -10,
      smallest_y: -10,
      biggest_x: 10,
      biggest_y: 10
    }

    current = %{
      smallest_x: -5,
      smallest_y: -5,
      biggest_x: 5,
      biggest_y: 15
    }

    actual = current |> Part1.is_not_inside_of(prev)

    assert actual == true
  end

  test "current is inside of prev" do
    prev = %{
      smallest_x: -10,
      smallest_y: -10,
      biggest_x: 10,
      biggest_y: 10
    }

    current = %{
      smallest_x: -5,
      smallest_y: -5,
      biggest_x: 5,
      biggest_y: 5
    }

    actual = current |> Part1.is_not_inside_of(prev)

    refute actual == true
  end

  test "get bounding box positions for points after 1 second", context do
    actual =
      context[:points_after_1_second]
      |> Part1.get_bounding_box()

    expected =
      %{
        smallest_x: -4,
        smallest_y: -5,
        biggest_x: 5,
        biggest_y: 9
      }

    assert expected == actual
  end

  test "get bounding box positions for initial points", context do
    actual =
      context[:initial_points]
      |> Part1.get_bounding_box()

    expected =
      %{
        smallest_x: -2,
        smallest_y: -3,
        biggest_x: 5,
        biggest_y: 5
      }

    assert expected == actual
  end

  test "apply velocities to first second", context do
    actual =
      context[:initial_points]
      |> Part1.apply_velocities()

    expected = context[:points_after_1_second]

    assert expected == actual
  end

  test "initial points parsed from list", context do
    actual = context[:initial_points]

    expected = Part1.Parser.create_points(
      [
        "position=< 0,  0> velocity=< 3,  0>",
        "position=< 5,  5> velocity=<-4,  4>",
        "position=< 4, -3> velocity=< 1, -2>",
        "position=<-2,  5> velocity=<-2, -5>",
      ]
    )

    assert actual == expected
  end

  test "initial points parsed from test file" do
    expected = [
      %{position: {9, 1}, velocity: {0, 2}},
      %{position: {7, 0}, velocity: {-1, 0}},
      %{position: {3, -2}, velocity: {-1, 1}},
      %{position: {6, 10}, velocity: {-2, -1}},
      %{position: {2, -4}, velocity: {2, 2}},
      %{position: {-6, 10}, velocity: {2, -2}},
      %{position: {1, 8}, velocity: {1, -1}},
      %{position: {1, 7}, velocity: {1, 0}},
      %{position: {-3, 11}, velocity: {1, -2}},
      %{position: {7, 6}, velocity: {-1, -1}},
      %{position: {-2, 3}, velocity: {1, 0}},
      %{position: {-4, 3}, velocity: {2, 0}},
      %{position: {10, -3}, velocity: {-1, 1}},
      %{position: {5, 11}, velocity: {1, -2}},
      %{position: {4, 7}, velocity: {0, -1}},
      %{position: {8, -2}, velocity: {0, 1}},
      %{position: {15, 0}, velocity: {-2, 0}},
      %{position: {1, 6}, velocity: {1, 0}},
      %{position: {8, 9}, velocity: {0, -1}},
      %{position: {3, 3}, velocity: {-1, 1}},
      %{position: {0, 5}, velocity: {0, -1}},
      %{position: {-2, 2}, velocity: {2, 0}},
      %{position: {5, -2}, velocity: {1, 2}},
      %{position: {1, 4}, velocity: {2, 1}},
      %{position: {-2, 7}, velocity: {2, -2}},
      %{position: {3, 6}, velocity: {-1, -1}},
      %{position: {5, 0}, velocity: {1, 0}},
      %{position: {-6, 0}, velocity: {2, 0}},
      %{position: {5, 9}, velocity: {1, -2}},
      %{position: {14, 7}, velocity: {-2, 0}},
      %{position: {-3, 6}, velocity: {2, -1}}
    ]

    actual = Part1.init_points("test.txt")

    assert actual == expected
  end
end



#
