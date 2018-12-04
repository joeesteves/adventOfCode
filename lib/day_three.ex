defmodule DayThree do
  def count_overlaped(data) when is_bitstring(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_claim/1)
    |> count_overlaped
  end

  def count_overlaped([head | tail], acc \\ %{}) do
    count_overlaped(tail, update_claim_map(head, acc))
  end

  def count_overlaped([], acc) do
    acc |> Enum.count(fn {k,v} -> v > 1 end)
  end

  def update_claim_map([left, top, width, height], acc) do
    Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
      Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
        Map.update(acc, {x, y}, 1, &(&1 + 1))
      end)
    end)
  end

  def parse_claim(claim) when is_binary(claim) do
    [[_ | coordinates] | _] =
      Regex.scan(~r/#\d* @ (\d{1,3}),(\d{1,3}): (\d{1,3})x(\d{1,3})/, claim)

    coordinates |> Enum.map(&String.to_integer/1)
  end
end
