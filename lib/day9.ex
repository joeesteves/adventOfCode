defmodule Day9 do
  def winning_score(players, last_marble) do
    [scores | _rest] =
      Enum.reduce(1..last_marble, [%{}, 0, [0], 1], fn curr_value,
                                                       [scores, curr_pos, curr_line, curr_player] ->
                                                        IO.puts curr_value
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
    {next_pos, add_score, next_line} =
      case curr_pos - 7 do
        n when n < 0 ->
          Tuple.insert_at(List.pop_at(curr_line, size + n), 0, size + n)

        n ->
          Tuple.insert_at(List.pop_at(curr_line, n), 0, n)
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
