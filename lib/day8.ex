defmodule Day8 do
  def sum_metadata(input) do
    numbers = parse_input(input)
    parse_numbers([], numbers, [])
  end

  @spec parse_numbers([integer], [integer], [integer]) :: integer
  def parse_numbers(left, [childs_q, metadata_q | rest], right) when childs_q > 0 do
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
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # Part 2
  def root_value(input) do
    numbers = parse_input(input)
    parse_numbers2([], numbers, [], [])
  end

  @spec parse_numbers2([integer], [integer], [integer], [integer]) :: integer
  def parse_numbers2(left, [childs_q, metadata_q | rest], right, child_values)
      when childs_q > 0 do
        IO.inspect "CHAU"
        IO.inspect child_values
    left = left ++ [childs_q, metadata_q]
    parse_numbers2(left, rest, right, [[] | child_values])
  end

  def parse_numbers2(left, [_, metadata_q | rest], right, [head_child | rest_childs] = aa) do
    {metadata, rest} = Enum.split(rest, metadata_q)

    going_back =
    case left do
      [] ->
        true

        _ ->
          {_, [c, _]} = Enum.split(left, -2)
          c - 1 == 0
        end
    IO.inspect going_back
    IO.inspect aa
IO.inspect rest_childs

    child_values =
      cond do
        going_back ->
          cond do
            is_list(head_child) ->
              IO.inspect "ooo"

              value =
                metadata
                |> Enum.map(fn i ->
                  case Enum.fetch(Enum.reverse(head_child), i - 1) do
                    {:ok, value} -> value
                    :error -> 0
                  end
                end)
                |> Enum.sum()

              case rest_childs do
                [vv | rr] when is_list(vv) ->
                  IO.inspect "..."
                  [[value | vv] | rr]

                [rr | rest] when is_integer(rr) ->
                  IO.inspect "xxx"

                  [value, rr | rest]
              end

            is_integer(head_child) ->
              value =
                metadata
                |> Enum.map(fn i ->
                  case Enum.fetch(Enum.reverse(aa), i - 1) do
                    {:ok, value} -> value
                    :error -> 0
                  end
                end)
                |> Enum.sum()

              [value]
          end

        true ->
          IO.inspect "HOOOl"
         [ [Enum.sum(metadata) | head_child ] | rest_childs ] |> IO.inspect
      end

    case left do
      [] ->
        parse_numbers2([], [], metadata ++ right, child_values)

      _ ->
        {ll, [c, m]} = Enum.split(left, -2)
        left = ll
        parse_numbers2(left, [c - 1, m] ++ rest, metadata ++ right, child_values)
    end
  end

  def parse_numbers2([], [], _right, [root_value]) do
    root_value
  end
end
