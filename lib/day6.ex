defmodule Day6 do
  @moduledoc """
  Documentation for Day6.
  """

  @doc """
  Gets the largest finite area

      iex> Day6.get_area_whitin_distance("1, 1
      ...>1, 6
      ...>8, 3
      ...>3, 4
      ...>5, 5
      ...>8, 9", 32)
      16
  """
  def get_area_whitin_distance(string, distance) do
    coordinates_list = parse_coordinates(string)

    {x_range, y_range} = get_extremes(coordinates_list)

    safe_coordinates =
      Enum.reduce(x_range, MapSet.new(), fn x, safe_cordinates ->
        Enum.reduce(y_range, safe_cordinates, fn y, safe_cordinates ->
          if is_whitin_distance({x, y}, distance, coordinates_list) do
            MapSet.put(safe_cordinates, {x, y})
          else
            safe_cordinates
          end
        end)
      end)

    MapSet.size(safe_coordinates)
  end

  def is_whitin_distance(target, distance, coordinates_list) do
    total = Enum.reduce(coordinates_list, 0, fn coordinate, acc ->
      acc = get_distance(target, coordinate) + acc
    end)
    total < distance
  end

  @doc """
  Gets the largest finite area

      iex> Day6.get_largest_area("1, 1
      ...>1, 6
      ...>8, 3
      ...>3, 4
      ...>5, 5
      ...>8, 9")
      17
  """
  def get_largest_area(string) when is_binary(string) do
    coordinates_list = parse_coordinates(string)
    extremes = get_extremes(coordinates_list)
    frame = get_frame_from_range(extremes)

    closes_map = get_closest_location_map(coordinates_list, extremes)

    frame_coordinates = get_closest_location_map(coordinates_list, frame)

    {_, v} =
      closes_map
      |> Enum.filter(fn {k, _} ->
        k not in frame_coordinates && k != {9999, 9999}
      end)
      |> Enum.max_by(fn {_, v} -> v end)

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

  def get_closest_location_map(locations, frame_list) do
    Enum.reduce(frame_list, MapSet.new(), fn {x, y}, acc ->
      location = get_closest_location_from_coordinate(locations, {x, y})
      MapSet.put(acc, location)
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

  @doc """
      iex> Day6.get_frame_from_range({1..3, 1..3})
      [{1,1},{1,2},{1,3},{2,1},{2,3},{3,1},{3,2},{3,3}]
  """
  def get_frame_from_range({x_range, y_range}) do
    x_min..x_max = x_range
    y_min..y_max = y_range

    Enum.reduce(x_range, [], fn x, acc ->
      Enum.reduce(y_range, acc, fn y, acc ->
        cond do
          x_min == x || x_max == x -> [{x, y} | acc]
          y_min == y || y_max == y -> [{x, y} | acc]
          true -> acc
        end
      end)
    end)
    |> Enum.reverse()
  end

  def get_distance({x, y}, {x_target, y_target}) do
    abs(abs(x - x_target) + abs(y - y_target))
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
end
