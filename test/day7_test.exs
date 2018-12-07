defmodule Day7Test do
  use ExUnit.Case

  @input """
  Step C must be finished before step A can begin.
  Step C must be finished before step F can begin.
  Step A must be finished before step B can begin.
  Step A must be finished before step D can begin.
  Step B must be finished before step E can begin.
  Step D must be finished before step E can begin.
  Step F must be finished before step E can begin.
  """
  @steps [
    ["C", "A"],
    ["C", "F"],
    ["A", "B"],
    ["A", "D"],
    ["B", "E"],
    ["D", "E"],
    ["F", "E"]
  ]

  @sorted_letters ["A", "B", "C", "D", "E", "F"]

  @deps_map %{
    "C" => {[], ["A", "F"]},
    "A" => {["C"], ["B", "D"]},
    "B" => {["A"], ["E"]},
    "E" => {["B", "D", "F"], []},
    "D" => {["A"], ["E"]},
    "F" => {["C"], ["E"]},
  }

  test "parse input" do
    assert Day7.parse(@input) == @steps
  end

  test "get all letters" do
    assert Day7.get_all_letters_az(@steps) == @sorted_letters
  end

  test "build deps map" do
    assert Day7.build_deps_map(@sorted_letters, @steps, %{}) == @deps_map
  end

  test "drive" do
    assert Day7.drive(@deps_map, []) == "CABDFE"
  end
end
