defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  @tag :five
  test "get closes location" do
    rta = Day6.get_closest_location_from_coordinate([{1,1}, {1,6}, {8,3}, {3,4}, {5,5}, {8,9}], {4,1})
    assert rta == {1,1}
  end
end
