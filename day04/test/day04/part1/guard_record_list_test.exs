defmodule Day04.Part1.GuardRecordListTest do
  use ExUnit.Case

  alias Day04.Part1.GuardRecordList

  setup_all do
    sorted_list =
      [
        {~N[1518-11-01 00:00:00], {:guard, 10}},
        {~N[1518-11-01 00:05:00], "falls asleep"},
        {~N[1518-11-01 00:25:00], "wakes up"},
        {~N[1518-11-01 00:30:00], "falls asleep"},
        {~N[1518-11-01 00:55:00], "wakes up"},
        {~N[1518-11-01 23:58:00], {:guard, 99}},
        {~N[1518-11-02 00:40:00], "falls asleep"},
        {~N[1518-11-02 00:50:00], "wakes up"},
        {~N[1518-11-03 00:05:00], {:guard, 10}},
        {~N[1518-11-03 00:24:00], "falls asleep"},
        {~N[1518-11-03 00:29:00], "wakes up"},
        {~N[1518-11-04 00:02:00], {:guard, 99}},
        {~N[1518-11-04 00:36:00], "falls asleep"},
        {~N[1518-11-04 00:46:00], "wakes up"},
        {~N[1518-11-05 00:03:00], {:guard, 99}},
        {~N[1518-11-05 00:45:00], "falls asleep"},
        {~N[1518-11-05 00:55:00], "wakes up"}
      ]

    {:ok, sorted_list: sorted_list}
  end

  test "GuardRecordList produces a sorted list from a sorted list", context do
    actual = GuardRecordList.read("test.txt")
    expected = context[:sorted_list]

    assert actual == expected
  end

  test "GuardRecordList produces a sorted list from a unsorted list", context do
    actual = GuardRecordList.read("test_unsorted.txt")
    expected = context[:sorted_list]

    assert actual == expected
  end
end
