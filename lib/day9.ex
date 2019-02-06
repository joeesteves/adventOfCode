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
    :ets.new(:scores, [:named_table])
      1..players
      |> Enum.into([])
      |> Stream.cycle()
      |> Stream.zip(1..last_marble)
      |> Enum.reduce(Circle.new(), fn {player, marble}, circle ->
        cond do
          rem(marble, 23) == 0 ->
            {value, circle} =
              Enum.reduce(1..7, circle, fn _, acc ->
                Circle.rotate_cww(acc)
              end)
              |> Circle.extract()

            points = marble + value

            unless :ets.insert_new(:scores, {player, points}) do
              curr_score = :ets.lookup_element(:scores, player, 2)
              :ets.update_element(:scores, player, {2, (curr_score + points)})
            end

            circle

          true ->
            Circle.rotate_cw(circle)
            |> Circle.add_marble(marble)
        end
      end)
      [val | _] = :ets.match(:scores, {:_, :"$1"}) |> Enum.max_by(fn [x | _] -> x end)
      val
    end
end
