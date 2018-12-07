defmodule Day7 do
  def parse(string) do
    String.split(string, "\n", trim: true)
    |> Enum.map(fn line ->
      letter1 = String.slice(line, 5, 1)
      letter2 = String.slice(line, 36, 1)
      [letter1, letter2]
    end)
  end

  def get_all_letters_az(steps) do
    Enum.flat_map(steps, & &1)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def build_deps_map([letter | rest], steps, acc) do
    acc =
      Map.put(acc, letter, {
        get_origins(letter, steps, []),
        get_destinations(letter, steps, [])
      })

    build_deps_map(rest, steps, acc)
  end

  def build_deps_map([], _, acc), do: acc


  def drive(deps_map, acc) when is_map(deps_map) do
    next_step =
    Enum.find(deps_map, fn {_, {deps, _}} ->
      deps -- acc == []
    end)

    case next_step do
      {fullfilled_letter, _} ->
        drive(Map.delete(deps_map, fullfilled_letter), [fullfilled_letter | acc])

        nil ->
          drive(:halt, acc)
        end
      end

    def drive(:halt, acc), do: acc |> Enum.reverse |> Enum.join

  defp get_origins(letter, [[o, letter] | tail], acc), do: get_origins(letter, tail, [o | acc])
  defp get_origins(letter, [_ | tail], acc), do: get_origins(letter, tail, acc)
  defp get_origins(_letter, [], acc), do: acc |> Enum.sort()

  defp get_destinations(letter, [[letter, d] | tail], acc),
    do: get_destinations(letter, tail, [d | acc])

  defp get_destinations(letter, [_ | tail], acc), do: get_destinations(letter, tail, acc)
  defp get_destinations(_letter, [], acc), do: acc |> Enum.sort()
end
