defmodule Day4 do
  import NimbleParsec

  @doc """
  Groups by id and date the parsed log

      iex> Day4.group_by_id_and_date([
      ...>     "[1518-11-04 00:02] Guard #99 begins shift",
      ...>     "[1518-11-01 00:05] falls asleep",
      ...>     "[1518-11-01 00:25] wakes up",
      ...>     "[1518-11-01 00:30] falls asleep",
      ...>     "[1518-11-05 00:03] Guard #99 begins shift",
      ...>     "[1518-11-04 00:36] falls asleep",
      ...>     "[1518-11-05 00:45] falls asleep",
      ...>     "[1518-11-01 23:58] Guard #99 begins shift",
      ...>     "[1518-11-04 00:46] wakes up",
      ...>     "[1518-11-03 00:29] wakes up",
      ...>     "[1518-11-05 00:55] wakes up",
      ...>     "[1518-11-03 00:24] falls asleep",
      ...>     "[1518-11-02 00:40] falls asleep",
      ...>     "[1518-11-01 00:55] wakes up",
      ...>     "[1518-11-01 00:00] Guard #10 begins shift",
      ...>     "[1518-11-03 00:05] Guard #10 begins shift",
      ...>     "[1518-11-02 00:50] wakes up"
      ...>  ])
      [
        {10, {1518, 11, 1}, [5..24, 30..54]},
        {99, {1518, 11, 1}, [40..49]},
        {10, {1518, 11, 3}, [24..28]},
        {99, {1518, 11, 4}, [36..45]},
        {99, {1518, 11, 5}, [45..54]},
      ]
  """
  def group_by_id_and_date(unsorted_logs_as_string) do
    unsorted_logs_as_string
    |> Enum.map(&parse_log/1)
    |> Enum.sort()
    |> group_by_id_and_date([])
  end

  def group_by_id_and_date([{date, hour, minute, {:shift, id}} | rest], groups) do
    {rest, ranges} = get_asleep_ranges(rest, [])
    group_by_id_and_date(rest, [{id, date, ranges} | groups])
  end

  def group_by_id_and_date([], groups), do: Enum.reverse(groups)

  def get_asleep_ranges([{_, _, down_minute, :down}, {_, _, up_minute, :up} | rest], ranges) do
    get_asleep_ranges(rest, [down_minute..(up_minute - 1) | ranges])
  end

  def get_asleep_ranges(rest, ranges) do
    {rest, ranges |> Enum.reverse()}
  end

  @doc """
  Parses guards_activity logs.
      iex> Day4.parse_log("[1518-11-01 00:00] Guard #10 begins shift")
      {{1518, 11, 01}, 00, 00, {:shift, 10}}

      iex> Day4.parse_log("[1518-11-01 00:05] falls asleep")
      {{1518, 11, 01}, 00, 05, :down}

      iex> Day4.parse_log("[1518-11-01 00:25] wakes up")
      {{1518, 11, 01}, 00, 25, :up}

  """
  def parse_log(string) when is_binary(string) do
    {:ok, [year, month, day, hour, minute, id], "", _, _, _} = parsec_log(string)
    {{year, month, day}, hour, minute, id}
  end

  defparsecp(
    :parsec_log,
    ignore(string("["))
    |> integer(4)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string(" "))
    |> integer(2)
    |> ignore(string(":"))
    |> integer(2)
    |> ignore(string("] "))
    |> choice([
      ignore(string("Guard #"))
      |> integer(min: 1)
      |> ignore(string(" begins shift"))
      |> unwrap_and_tag(:shift),
      string("falls asleep") |> replace(:down),
      string("wakes up") |> replace(:up)
    ])
  )

  @doc """
      iex> Day4.sum_asleep_times_by_id([
      ...>  {10, {1518, 11, 1}, [5..24, 30..54]},
      ...>  {99, {1518, 11, 1}, [40..49]},
      ...>  {10, {1518, 11, 3}, [24..28]},
      ...>  {99, {1518, 11, 4}, [36..45]},
      ...>  {99, {1518, 11, 5}, [45..54]},
      ...>  ])
      %{
        99 => 30,
        10 => 50
      }
  """
  def sum_asleep_times_by_id(grouped_entries) do
    Enum.reduce(grouped_entries, %{}, fn {id, _date, ranges}, acc ->
      time_asleep = ranges |> Enum.map(&Enum.count/1) |> Enum.sum()
      Map.update(acc, id, time_asleep, &(&1 + time_asleep))
    end)
  end

  @doc """
      iex> Day4.id_that_asleep_the_most(%{99 => 30, 10 => 50})
      10
  """
  def id_that_asleep_the_most(map) do
    {id, _} = Enum.max_by(map, fn {_, time_asleep} -> time_asleep end)
    id
  end

  @doc """
      iex> Day4.minute_asleep_the_most_by_id([
      ...>  {10, {1518, 11, 1}, [5..24, 30..54]},
      ...>  {99, {1518, 11, 1}, [40..49]},
      ...>  {10, {1518, 11, 3}, [24..28]},
      ...>  {99, {1518, 11, 4}, [36..45]},
      ...>  {99, {1518, 11, 5}, [45..54]},
      ...>  ], 10)
      { 24, 2 }
  """
  def minute_asleep_the_most_by_id(list, id) do

    all_minutes =
      for {^id, _, ranges} <- list,
          range <- ranges,
          minute <- range,
          do: minute
    case all_minutes do
      [] -> nil
      _ ->
        minutes_occurrences =
          Enum.reduce(all_minutes, %{}, fn minute, acc ->
            Map.update(acc, minute, 1, &(&1 + 1))
          end)

        {minute, ocurrencies} = Enum.max_by(minutes_occurrences, fn {_, ocurrencies} -> ocurrencies end)
        { minute, ocurrencies }
      end
  end

  @doc """
      iex> Day4.part1("test4.txt")
      240
  """
  def part1(input) do
    group = group_by_id_and_date_on_input(input)

    id =
      group
      |> sum_asleep_times_by_id
      |> id_that_asleep_the_most

    { minute, _ } = minute_asleep_the_most_by_id(group, id)
    minute * id
  end

  @doc """
      iex> Day4.part2("test4.txt")
      4455
  """
  def part2(input) do
    group = group_by_id_and_date_on_input(input)

    map =
      Enum.reduce(group, %{}, fn {id, _, _}, acc ->
        case acc do
          %{^id => _ } -> acc
          %{} ->
            case minute_asleep_the_most_by_id(group, id) do
              nil -> acc
              minute_occ -> Map.put(acc, id, minute_occ)
            end
        end
      end)

      {id, {minute, occ}} = Enum.max_by(map, fn {_ , {min, occ}} -> occ end)
      id * minute
  end

  def group_by_id_and_date_on_input(input) do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> group_by_id_and_date
  end
end
