defmodule DayThree do
  def count_overlaped(data) when is_bitstring(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_claim/1)
    |> map_coordinates
    |> Enum.count(fn {_k, v} -> length(v) > 1 end)
  end

  def get_not_overlaped(data) when is_bitstring(data) do
    cc = data
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_claim/1)
    |> map_coordinates
    |> Enum.filter(fn {_k, v} -> length(v) == 1 end)
    |> Enum.flat_map(fn {_k, v} -> v end)
    |> Enum.group_by(&(&1))
    |> Enum.reduce(%{}, fn {k,v}, acc ->
      Map.put(acc, k, length(v))
    end)

    data
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_claim/1)
    |> Enum.find_value(fn [id, _, _, w, h] ->
      Map.get(cc, id) == w * h && id
    end)
  end

  def map_coordinates(_, acc \\ %{})

  def map_coordinates([head | tail], acc) do
    map_coordinates(tail, update_claim_map(head, acc))
  end

  def map_coordinates([], acc) do
    acc
  end

  def update_claim_map([id, left, top, width, height], acc) do
    Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
      Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
        Map.update(acc, {x, y}, [id], &[id | &1])
      end)
    end)
  end

  def parse_claim(claim) when is_binary(claim) do
    [[_ | coordinates] | _] =
      Regex.scan(~r/#(\d*) @ (\d{1,3}),(\d{1,3}): (\d{1,3})x(\d{1,3})/, claim)

    coordinates |> Enum.map(&String.to_integer/1)
  end
end
