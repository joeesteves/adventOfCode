defmodule Day7 do
  def bundle(input) do
    steps = parse(input)

    steps
    |> get_all_letters_az
    |> build_deps_map(steps, %{})
    |> drive([])
  end

  def bundle2(input) do
    steps = parse(input)

    steps
    |> get_all_letters_az
    |> build_deps_map(steps, %{})
    |> timer(5, 60)
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
    available =
      Enum.filter(deps_map, fn {_, {deps, _}} -> deps == [] end)
      |> Enum.map(fn {k, {deps, dest}} -> {k, {key_to_time(k, secs), deps, dest}} end)
      |> Enum.into(%{})

    un_available =
      Map.drop(deps_map, Map.keys(available))
      |> Enum.map(fn {k, {deps, dest}} -> {k, {key_to_time(k, secs), deps, dest}} end)
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
    timer([], available, %{}, not_available, workers, 0)
  end

  def timer(_finished_acc, wip, _available, _not_available, _workers, acc) when wip == %{} do
    acc
  end

  def timer(finished_acc, wip, available, not_available, workers, acc) do
    # Removes one to remain
    wip =
      Enum.map(wip, fn {k, {remain, deps, dest}} ->
        {k, {remain - 1, deps, dest}}
      end)
      |> Enum.into(%{})

    # finished
    finished =
      Enum.filter(wip, fn {_k, {remain, _, _}} ->
        remain == 0
      end)

    finished_keys =
      finished
      |> Enum.map(fn {k, _} -> k end)

    wip = Map.drop(wip, finished_keys)
    finished_acc = finished_keys ++ finished_acc

    # update not available
    pass_to_available_keys =
      finished
      |> Enum.flat_map(fn {_, {_, _deps, dest}} -> dest end)
      |> Enum.filter(fn pk ->
        case Map.get(not_available, pk) do
          {_, deps, _dest} ->
            deps -- finished_acc == []

          nil ->
            false
        end
      end)

    pass_to_available =
      Enum.filter(
        not_available,
        fn {k, _} -> k in pass_to_available_keys end
      )
      |> Enum.into(%{})

    not_available = Map.drop(not_available, pass_to_available_keys)

    # update available
    available = Map.merge(available, pass_to_available) |> Enum.sort() |> Enum.into(%{})

    wip_can_receive = workers - (Map.keys(wip) |> length)

    going_to_work = Enum.take(available, wip_can_receive) |> Enum.into(%{})

    # update work in progress
    wip = Map.merge(wip, going_to_work)
    going_to_work_keys = Map.keys(going_to_work)

    available = Map.drop(available, going_to_work_keys)

    timer(finished_acc, wip, available, not_available, workers, acc + 1)
  end

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
