defmodule Day9.Circle do
  def new(), do: {[], 0, []}

  def current({_, current, _}), do: current

  def rotate_cw({[first_left | left], current, []}) do
    {[], first_left, append(left, current)}
  end

  def rotate_cw({left, current, [right_first | right]}) do
    {append(left, current), right_first, right}
  end

  def rotate_cww(circle, 0), do: circle

  def rotate_cww({left, current, right}, n) do

    {leftnew_current,[current | right]}
  end

  def rotate_cw(circle), do: circle

  def add_marble({left, current, right}, value) do
    {append(left,current), value, right}
  end

  def append(list, value) do
    list ++ [value]
  end
end


defmodule Day9 do
  def winning_score(players, last_marble) do
    [scores | _rest] =
      Enum.reduce(1..last_marble, [%{}, 0, [0], 1], fn curr_value,
                                                       [scores, curr_pos, curr_line, curr_player] ->
        {next_pos, next_line, line_score} = next_pos_line(curr_pos, curr_line, curr_value)

        scores = Map.update(scores, curr_player, line_score, &(&1 + line_score))

        [scores, next_pos, next_line, next_player(players, curr_player)]
      end)

    Enum.max_by(scores, fn {x, v} -> v end)
  end

  def next_player(players, curr_player) do
    case curr_player + 1 do
      n when n > players ->
        1

      n ->
        n
    end
  end

  def next_pos_line(curr_pos, curr_line, curr_value) do
    next_pos_line(curr_pos, curr_line, curr_value, length(curr_line))
  end

  def next_pos_line(curr_pos, curr_line, curr_value, size) when rem(curr_value, 23) == 0 do
    {{add_score, next_line}, next_pos} =
      case curr_pos - 7 do
        n when n < 0 ->
          {List.pop_at(curr_line, size + n), size + n}

        n ->
          {List.pop_at(curr_line, n), n}
      end

    {next_pos, next_line, curr_value + add_score}
  end

  def next_pos_line(curr_pos, curr_line, curr_value, size) do
    next_pos =
      case curr_pos + 2 do
        n when n > size ->
          n - size

        n ->
          n
      end

    next_line = List.insert_at(curr_line, next_pos, curr_value)
    {next_pos, next_line, 0}
  end
end
