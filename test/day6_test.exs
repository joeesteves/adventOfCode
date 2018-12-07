defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  @tag :six
  test "get area" do
    input = """
    4, 1
    5, 3
    8, 2
    7, 6
    4, 6
    6, 4
    """

    assert Day6.get_largest_area(input) == 3
  end

  @tag :five
  test "get closes location" do
    rta =
      Day6.get_closest_location_from_coordinate(
        [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}],
        {4, 1}
      )

    assert rta == {1, 1}
  end
end
