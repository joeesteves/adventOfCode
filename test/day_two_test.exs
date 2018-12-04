defmodule DayTwoTest do
  use ExUnit.Case

  @tag :two
  test "get_twice_and_thrice" do
    data = """
    bababc
    abcdef
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
    """

    assert DayTwo.checksum(data) == 12
  end
end
