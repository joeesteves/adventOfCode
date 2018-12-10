defmodule Day8Tesd do
  use ExUnit.Case

  @input "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

  test "sum_metadata" do
    assert Day8.sum_metadata(@input) == 138
  end

  test "root_value" do
    assert Day8.root_value(@input) == 66
  end
end
