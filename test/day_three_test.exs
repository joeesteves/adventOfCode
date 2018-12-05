defmodule DayThreeTest do
  use ExUnit.Case

  test "parse claim" do
    assert DayThree.parse_claim("#1 @ 1,3: 4x4") == [1, 1, 3, 4, 4]
  end

  test "count overlaped" do
    data = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert DayThree.count_overlaped(data) == 4
  end

  @tag :three
  test "get not overlaped" do
    data = """
    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2
    """

    assert DayThree.get_not_overlaped(data) == 3
  end
end
