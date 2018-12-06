defmodule Day6 do
  @moduledoc """
  Documentation for Day6.
  """

  @doc """
  Gets the larges finite area

      iex> Day6.get_largest_area("1, 1
      ...>1, 6
      ...>8, 3
      ...>3, 4
      ...>5, 5
      ...>8, 9")
      17
  """
  def get_largest_area(string) when is_binary(string) do
    coordinades_list = parse_coordinates(string)
    extremes = get_extremes(coordinades_list)
    finite_coordinades = get_finite_coordinates(coordinades_list, extremes)
    closes_map = get_closest_location_map(coordinades_list, extremes)

    {_, v} =
      closes_map
      |> Enum.filter(fn {k, _} ->
        k in finite_coordinades
      end)
      |> IO.inspect()
      |> Enum.max_by(fn {_, v} -> v end)
      |> IO.inspect()

    v
  end

  @doc """
  Gets closes for location maf

      iex> Day6.get_closest_location_map([{1,1}, {1,6}, {8,3}, {3,4}, {5,5}, {8,9}], {1..8, 1..9})
      %{
        {1,1} => 7,
        {1,6} => 9,
        {8,3} => 12,
        {3,4} => 9,
        {5,5} => 17,
        {8,9} => 10,
        {9999, 9999} => 8,
      }
  """
  def get_closest_location_map(locations, {x_range, y_range}) do
    Enum.reduce(x_range, %{}, fn x, acc ->
      Enum.reduce(y_range, acc, fn y, acc ->
        location = get_closest_location_from_coordinate(locations, {x, y})
        Map.update(acc, location, 1, &(&1 + 1))
      end)
    end)
  end

  @doc """
  Gets de closes location to coordinate
      iex> Day6.get_closest_location_from_coordinate([{1,1}, {1,6}, {8,3}, {3,4}, {5,5}, {8,9}], {4,1})
      {1,1}
      iex> Day6.get_closest_location_from_coordinate([{1,1}, {1,6}, {8,3}, {3,4}, {5,5}, {8,9}], {9,8})
      {8,9}
      iex> Day6.get_closest_location_from_coordinate([{1,1}, {1,6}, {8,3}, {3,4}, {5,5}, {8,9}], {5,0})
      {9999,9999}
      iex> Day6.get_closest_location_from_coordinate([{1,1}, {1,6}, {8,3}, {3,4}, {5,5}, {8,9}], {5,2})
      {5,5}

  """
  def get_closest_location_from_coordinate(locations, target) do
    locations =
      locations
      |> Enum.reduce({{9999, 9999}, nil}, fn location, {location_acc, repeated} ->
        curr_distance = get_distance(target, location)
        acc_distance = get_distance(target, location_acc)

        cond do
          curr_distance < acc_distance -> {location, repeated}
          curr_distance == acc_distance -> {location, location}
          curr_distance > acc_distance -> {location_acc, repeated}
        end
      end)

    case locations do
      {location, nil} ->
        location

      {location, repeated} ->
        cond do
          get_distance(location, target) < get_distance(repeated, target) ->
            location

          true ->
            {9999, 9999}
        end
    end
  end

  def get_distance({x, y}, {x_target, y_target}) do
    abs(abs(x - x_target) + abs(y - y_target))
  end

  @doc """
  Parse text into coordinate collection [{x, y},...]

      iex> Day6.parse_coordinates("1, 1
      ...>1, 6
      ...>8, 3
      ...>3, 4
      ...>5, 5
      ...>8, 9")
      [{1,1}, {1,6}, {8,3}, {3,4}, {5,5}, {8,9}]
  """
  def parse_coordinates(string) when is_binary(string) do
    String.split(string, "\n", trim: true)
    |> Enum.map(fn coordinate ->
      String.split(coordinate, ", ")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  @doc """
  Gets finite coordinates [{x, y},...]

      iex> Day6.get_finite_coordinates([{1,1}, {1,6}, {8,3}, {3,4}, {5,5}, {8,9}], {1..8, 1..9})
      [{3,4}, {5,5}]
  """
  def get_finite_coordinates(coordinates, extremes) do
    {x_min..x_max, y_min..y_max} = extremes
    x_range = (x_min + 1)..(x_max - 1)
    y_range = (y_min + 1)..(y_max - 1)

    Enum.filter(coordinates, fn {x, y} ->
      x in x_range && y in y_range
    end)
  end

  @doc """
  Gets extremas in ranges from coordinates [{x, y},...]

      iex> Day6.get_extremes([{1,1}, {1,6}, {8,3}, {3,4}, {5,5}, {8,9}])
      {1..8,1..9}
  """
  def get_extremes([{x, y} | rest]) do
    get_extremes(rest, {x..x, y..y})
  end

  def get_extremes([{x, y} | rest], {x_min..x_max, y_min..y_max}) do
    x_extremes = ((x < x_min && x) || x_min)..((x > x_max && x) || x_max)
    y_extremes = ((y < y_min && y) || y_min)..((y > y_max && y) || y_max)
    get_extremes(rest, {x_extremes, y_extremes})
  end

  def get_extremes(_, extremes), do: extremes
end
