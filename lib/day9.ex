defmodule Day9 do
  #
  def winning_score(players, last_marble) do
    Enum.reduce(1..last_marble, {%{}, [0], 0, 1},fn curr_marble_value, {scores, line, curr_marble_position, curr_player } ->

      {scores, line, next_player(players, curr_player)}
    end)
  end

  def next_player(players, curr_player) do
    case curr_player + 1 do
      n when n > players ->
        1
      n -> n
    end
  end

  def next_pos_line(curr_pos, curr_line, curr_marble_value) do
    curr_line_size = length(curr_line)
    next_pos = case curr_pos + 2 do
      n when n > curr_line_size ->
        n - curr_line_size
      n -> n
    end
    next_line = List.insert_at(curr_line, next_pos, curr_marble_value)
    {next_pos, next_line}
  end
end
