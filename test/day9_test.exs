defmodule Day9Test do
  use ExUnit.Case
  alias Day9.Circle

  @tag :win
  test "winning_score" do
    assert Day9.winning_score(9, 25)  == 32
    assert Day9.winning_score(10, 1_618)  == 8_317
    assert Day9.winning_score(13, 7_999)  == 146_373
    assert Day9.winning_score(17, 1_104)  == 2_764
    assert Day9.winning_score(21, 6_111)  == 54_718
    assert Day9.winning_score(30, 5_807)  == 37_305
  end

  @tag :circle
  test "rotate_cw" do
    assert Circle.rotate_cw({[1, 2, 3, 4, 5, 6, 7, 8, 9], [10]}) ==
             {[10], [9, 8, 7, 6, 5, 4, 3, 2, 1]}

    assert Circle.rotate_cw({[1, 2], [10, 3, 4, 5, 6, 7, 8, 9]}) ==
             {[10, 1, 2], [3, 4, 5, 6, 7, 8, 9]}
  end

  @tag :cww
  test "rotate_cww" do
    assert Circle.rotate_cww({[1, 2, 3, 4, 5, 6, 7, 8, 9], [10]}) ==
             {[2, 3, 4, 5, 6, 7, 8, 9], [1, 10]}

    assert Circle.rotate_cww({[1, 2], [10, 3, 4, 5, 6, 7, 8, 9]}) ==
             {[2], [1, 10, 3, 4, 5, 6, 7, 8, 9]}
  end

  @tag :extract
  test "extract" do
    assert Circle.extract({[1, 2, 3, 4, 5, 6, 7, 8, 9], [10]}) ==
             {10, {[1, 2, 3, 4, 5, 6, 7, 8, 9], []}}

    assert Circle.extract({[1, 2], [10, 3, 4, 5, 6, 7, 8, 9]}) ==
             {10, {[1, 2], [3, 4, 5, 6, 7, 8, 9]}}

    assert Circle.extract({[1, 2], [10]}) ==
             {10, {[1, 2], []}}
  end

  @tag :bm
  test "benchmark" do
    {time, val} = :timer.tc(fn -> Day9.winning_score(452, 7_125_000) end)
    IO.puts "my"
    IO.inspect(time / :math.pow(10, 6))

    assert val == 3212081616
  end

  @tag :bm
  test "benchmark other" do
    {time, val} = :timer.tc(fn -> Advent.Day9.high_score(452, 7_125_000) end)
    IO.inspect "other"
    IO.inspect(time / :math.pow(10, 6))

    assert val == 3212081616
  end
end
