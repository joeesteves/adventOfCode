defmodule DayThree do
  def count_overlaped(data) when is_bitstring(data) do
    data
    |> String.split("\n", trim: true)
    |> count_overlaped
  end

  def count_overlaped([head | tail]) do

  end

  def parse_claim(claim) when is_bitstring(claim) do
    [[_ | coordinates] | _ ] = Regex.scan(~r/#(\d*) @ (\d{1,3}),(\d{1,3}): (\d{1,3})x(\d{1,3})/, claim)
    coordinates |> Enum.map(&String.to_integer/1) |> List.to_tuple
  end

end
