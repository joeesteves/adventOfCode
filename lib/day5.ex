defmodule Day5 do
  @doc """
    Removes adjacents when they have opposite polarity (determined by case Aa), it recurses over result until there are no further adyacent oposites
      iex> Day5.react("dabAcCaCBAcCcaDA")
      "dabCBAcaDA"
  """
  def react(polymer) when is_binary(polymer), do: discard_and_react(polymer, [], nil, nil)

  @doc """
      iex> Day5.discard_and_react("dabAcCaCBAcCcaDA", ?A, ?a)
      "dbCBcD"
  """
  def discard_and_react(polymer, discard1, discard2) when is_binary(polymer),
    do: discard_and_react(polymer, [], discard1, discard2)

  def discard_and_react(<<letter1, rest::binary>>, acc, discard1, discard2)
      when letter1 == discard1
      when letter1 == discard2,
      do: discard_and_react(rest, acc, discard1, discard2)

  def discard_and_react(<<letter1, rest::binary>>, [letter2 | acc], discard1, discard2)
      when abs(letter1 - letter2) == 32,
      do: discard_and_react(rest, acc, discard1, discard2)

  def discard_and_react(<<letter, rest::binary>>, acc, discard1, discard2),
    do: discard_and_react(rest, [letter | acc], discard1, discard2)

  def discard_and_react(<<>>, acc, _letter1, _letter2),
    do: Enum.reverse(acc) |> List.to_string()

  @doc """
      iex> Day5.find_problematic("dabAcCaCBAcCcaDA")
      {?C, 4}
  """
  def find_problematic(polymer) do
    for letter <- ?A..?Z do
      {letter, byte_size(discard_and_react(polymer, letter, letter + 32))}
    end
    |> Enum.min_by(fn {letter, length} -> length end)
  end
end
