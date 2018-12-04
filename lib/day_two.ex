defmodule DayTwo do

  defp get_twice_and_thrice(str_line) do
    str_line
    |> String.codepoints
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, x, 1, &(&1 + 1))
    end)
    |> Enum.reduce({0,0}, fn {_k,v} , {twice, thrice} ->
      case v do
        2 -> {1, thrice}
        3 -> {twice, 1}
        _ -> { twice, thrice}
      end
    end)
  end

  def checksum(data_string) do
    { twice, thrice } = data_string
    |> String.split("\n", trim: true)
    |> Enum.map(&get_twice_and_thrice/1)
    |> Enum.reduce({0, 0}, fn {twice, thrice}, {twice_acc, thrice_acc} ->
      {twice_acc + twice, thrice_acc + thrice}
    end)
    twice * thrice
  end

end
