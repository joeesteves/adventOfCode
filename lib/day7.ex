defmodule Day7 do
  def bundle(input) do
    steps = parse(input)

    steps
    |> get_all_letters_az
    |> build_deps_map(steps, %{})
    |> drive([])
  end

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

  def prepare_data(deps_map, secs) do
    {k, {_, dest}} = Enum.find(deps_map, fn {_, {deps, _}} -> deps == [] end)

    available = %{k => {key_to_time(k, secs), dest}}

    un_available =
      Map.delete(deps_map, k)
      |> Enum.map(fn {k, {_, dest}} -> {k, {key_to_time(k, secs), dest}} end)
      |> Enum.into(%{})

    {available, un_available}
  end

  defp key_to_time(k, secs) do
    codepoint =
      String.to_charlist(k)
      |> List.first()

    codepoint - 64 + secs
  end

  def timer(deps_map, workers, add_time) do
    {available, not_available} = prepare_data(deps_map, add_time)
    timer(available, %{}, not_available, workers, 0)
  end

  def timer(wip, available, not_available, workers, acc) do
    wip =
      Enum.map(wip, fn {k, {remain, dest}} ->
        {k, {remain - 1, dest}}
      end)
      |> Enum.into(%{})

    pass_to_available =
      Enum.filter(wip, fn {_, {remain, _}} ->
        remain == 0
      end)
      |> Enum.flat_map(fn {_, {_, dest}} -> dest end)




  end

  def timer(%{}, available, not_available, workers, acc), do: acc

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

  def drive(:halt, acc), do: acc |> Enum.reverse() |> Enum.join()

  defp get_origins(letter, [[o, letter] | tail], acc), do: get_origins(letter, tail, [o | acc])
  defp get_origins(letter, [_ | tail], acc), do: get_origins(letter, tail, acc)
  defp get_origins(_letter, [], acc), do: acc |> Enum.sort()

  defp get_destinations(letter, [[letter, d] | tail], acc),
    do: get_destinations(letter, tail, [d | acc])

  defp get_destinations(letter, [_ | tail], acc), do: get_destinations(letter, tail, acc)
  defp get_destinations(_letter, [], acc), do: acc |> Enum.sort()
end
