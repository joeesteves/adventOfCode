defmodule Day9.Circle do
  def new(), do: {[], [0]}
  def current({_, [current | _]}), do: current

  def rotate_cw({left, [current | right]}) do
    {[current | left], right}
  end

  def rotate_cw({left, []}) do
    rotate_cw({[], Enum.reverse(left)})
  end

  def rotate_cw(circle), do: circle

  def rotate_cww({left, current, right}) when length(left) > 6 do
    {time, circle} =
      :timer.tc(fn ->
        dif = length(left) - 7
        {left, [next_current | head_rigth]} = Enum.split(left, dif)
        {left, next_current, head_rigth ++ [current] ++ right}
      end)

    IO.inspect("---CWW---")
    IO.inspect(time)
    circle
  end

  def rotate_cww({left, current, right}) do
    {time, circle} =
      :timer.tc(fn ->
        dif = length(right) - (7 - length(left))
        {tail_left, [next_current | new_right]} = Enum.split(right, dif)
        {left ++ [current] ++ tail_left, next_current, new_right}
      end)

    IO.inspect("***CWW***")
    IO.inspect(time)
    circle
  end

  def extract({[head_left | left], current, []}) do
    {current, {[], head_left, left}}
  end

  def extract({left, current, [head_right | right]}) do
    {current, {left, head_right, right}}
  end

  def add_marble({left, current, right}, value) do
    {append(left, current), value, right}
  end

  defp append(list, value) do
    list ++ [value]
  end
end

defmodule Day9 do
  alias Day9.Circle

  def winning_score(players, last_marble) do
    {scores, _} =
      Stream.cycle(1..players)
      |> Stream.zip(1..last_marble)
      |> Enum.reduce({%{}, Circle.new()}, fn {player, marble}, {scores, circle} ->
        cond do
          rem(marble, 23) == 0 ->
            {value, circle} =
              Circle.rotate_cww(circle)
              |> Circle.extract()

            scores = Map.update(scores, player, value + marble, &(&1 + value + marble))
            {scores, circle}

          true ->
            circle =
              Circle.rotate_cw(circle)
              |> Circle.add_marble(marble)

            {scores, circle}
        end
      end)

    Enum.max_by(scores, fn {x, v} -> v end)
  end
end
