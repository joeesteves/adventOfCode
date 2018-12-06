defmodule DayTwo do

  def closest(data) when is_bitstring(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> closest
  end

  def closest([head | tail]) do
    Enum.find_value(tail, &(one_char_diff(head, &1))) || closest(tail)
  end


  defp one_char_diff(cl1, cl2) do
    cl1
    |> Enum.zip(cl2)
    |> Enum.split_with( fn {cp1, cp2} -> cp1 == cp2 end)
    |> case do
      {tuples_of_codepoints, [_]} ->
        tuples_of_codepoints
        |> Enum.map(fn {cp, _} -> cp end)
        |> List.to_string
      _ -> nil
    end
  end



  def checksum(data_string) when is_binary(data_string) do
    { twice, thrice } = data_string
    |> String.split("\n", trim: true)
    |> Enum.map(&get_twice_and_thrice/1)
    |> Enum.reduce({0, 0}, fn {twice, thrice}, {twice_acc, thrice_acc} ->
      {twice_acc + twice, thrice_acc + thrice}
    end)
    twice * thrice
  end

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

end
