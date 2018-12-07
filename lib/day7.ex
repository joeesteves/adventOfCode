defmodule Day7 do
  def parse(string) do
    String.split(string, "\n", trim: true)
    |> Enum.map(fn line ->
      letter1 = String.slice(line, 5, 1)
      letter2 = String.slice(line, 30, 1)
      [letter1, letter2 ]
    end)
  end

  def get_all_letters_az(steps) do
    Enum.flat_map(steps, &(&1))
    |> Enum.uniq
    |> Enum.sort
  end

end
