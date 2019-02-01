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


end
