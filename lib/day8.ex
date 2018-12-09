defmodule Day8 do
  def sum_metadata(input) do
    numbers = parse_input(input)
    parse_numbers([], numbers, [])
  end

  @spec parse_numbers([integer], [integer], [integer]) :: integer
  def parse_numbers(left, [childs_q, metadata_q | rest] = q, right) when childs_q > 0 do
    left = left ++ [childs_q, metadata_q]
    parse_numbers(left, rest, right)
  end

  def parse_numbers(left, [_, metadata_q | rest], right) do
    {metadata, rest} = Enum.split(rest, metadata_q)

    case left do
      [] ->
        parse_numbers([], [], metadata ++ right)

      _ ->
        {ll, [c, m]} = Enum.split(left, -2)
        left = ll
        parse_numbers(left, [c - 1, m] ++ rest, metadata ++ right)
    end
  end

  def parse_numbers([], [], right) do
    Enum.sum(right)
  end

  def parse_input(input) do
    String.replace(input, ~r/\n/, "")
    |> String.split( " ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
