defmodule Day9Test do
  use ExUnit.Case

  test "winning_score" do
    assert Day9.winning_score(9, 25) == 32
    assert Day9.winning_score(10, 1_618) == 8_317
    assert Day9.winning_score(13, 7_999) == 146_373
    assert Day9.winning_score(17, 1_104) == 2_764
    assert Day9.winning_score(21, 6_111) == 54_718
    assert Day9.winning_score(30, 5807) == 37_305
  end

  test "next_player" do
    assert Day9.next_player(10,9) == 10
    assert Day9.next_player(10,10) == 1
  end

  @tag :focus
  test "next_pos_line" do
    assert Day9.next_pos_line(0, [0], 1) == {1, [0,1]}
    assert Day9.next_pos_line(3, [0,2,1,3], 4) == {1, [0,4,2,1,3]}
    assert Day9.next_pos_line(1, [0,4,2,1,3], 5) == {3, [0,4,2,5,1,3]}
  end

end
