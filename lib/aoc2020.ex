defmodule Aoc2020 do
  @moduledoc """
  Documentation for Aoc2020.
  """

  @tree "#"

  @doc """
  Takes the string +input+ and processes it.

  ## Examples
  iex> [~w[. . # # . . . . . . .],
  iex> ~w[# . . . # . . . # . .],
  iex> ~w[. # . . . . # . . # .],
  iex> ~w[. . # . # . . . # . #],
  iex> ~w[. # . . . # # . . # .],
  iex> ~w[. . # . # # . . . . .],
  iex> ~w[. # . # . # . . . . #],
  iex> ~w[. # . . . . . . . . #],
  iex> ~w[# . # # . . . # . . .],
  iex> ~w[# . . . # # . . . . #],
  iex> ~w[. # . . # . . . # . #]] |> Aoc2020.run()
  336
  """
  def run(input) do
    length = get_length(Enum.at(input, 0))

    moves = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

    moves
    # find the tree count for each set of +moves+
    |> Enum.reduce([], fn moves, acc -> [count_trees(input, length, moves) | acc] end)
    # multiply the results
    |> Enum.reduce(1, &(&1 * &2))
  end

  def parse_line(line) when is_binary(line), do: String.trim(line) |> String.graphemes()
  def parse_line(line), do: line

  def get_length(line) when is_binary(line), do: String.trim(line) |> String.length()
  def get_length(line), do: length(line)

  def tree?(line, {num, acc = %{move: {x, y}, i: i}}) do
    # increment the slope index, +i+
    acc = Map.put(acc, :i, acc.i + 1)

    case y do
      # when +y+ is 1, we can use the same formula from 3a
      1 ->
        {num + increment_amount(line, x, i, acc.length), acc}

      # otherwise, we can only check even rows
      _ ->
        cond do
          # our very first row doesn't need to be counted, even though it's even
          y > 0 && i == 0 ->
            {num, acc}

          # if this is an even row, check for a tree
          rem(i, y) == 0 ->
            # pass both +x+ and +y+ so we can determine the current index on the slope
            {num + increment_amount(line, {x, y}, i, acc.length), acc}

          # if it's not even and it's not the very first row, it must be odd. don't count it
          true ->
            {num, acc}
        end
    end
  end

  def count_trees(stream, slope_length, {x, y}) do
    stream
    # clean up the line
    |> Stream.map(&parse_line/1)
    # scan the stream count the number of trees
    |> Stream.scan({0, %{i: 0, length: slope_length, move: {x, y}}}, &tree?/2)
    # all we need is the count, not the accumulator
    |> Stream.map(fn {i, _} -> i end)
    # we want the last (highest) number
    |> Enum.reverse()
    |> hd()
  end

  # When +y+ isn't 1, we need to divide the current +index+ by +y+
  # to get the current position.
  def increment_amount(slope, {x, y}, index, slope_length) do
    (Enum.at(slope, rem(div(index, y) * x, slope_length)) === @tree && 1) || 0
  end

  def increment_amount(slope, moves, index, slope_length) do
    (Enum.at(slope, rem(index * moves, slope_length)) === @tree && 1) || 0
  end
end
