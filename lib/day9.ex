defmodule Day9.Circle do
  def new(), do: {[], [0]}

  def current({_, [current | _]}), do: current

  def rotate_cw({[], [0]}), do: new()

  def rotate_cw({left, [current | []]}) do
    rotate_cw({[], [current | Enum.reverse(left)]})
  end

  def rotate_cw({left, [current | right]}) do
    {[current | left], right}
  end

  def rotate_cww({[current | left], right}) do
    {left, [current | right]}
  end

  def rotate_cww({[], right}) do
    {Enum.reverse(right), []}
    |> rotate_cww
  end

  def extract({left, [current | right]}) do
    {current, {left, right}}
  end

  def add_marble({left, [current | right]}, marble) do
    {[current | left], [marble | right]}
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
            {value, circle} = Enum.reduce(1..7, circle, fn _, acc ->
                Circle.rotate_cww(acc)
              end)
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

  end
end
