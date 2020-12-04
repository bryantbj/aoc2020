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
  7
  """
  def run(input) do
    length = get_length(Enum.at(input, 0))

    input
    |> Stream.map(&parse_line/1)
    |> Stream.scan({0, %{i: 0, length: length}}, &tree?/2)
    |> Stream.map(fn {i, _} -> i end)
    |> Enum.reverse()
    |> (fn [hd | _] -> hd end).()
    |> IO.inspect()
  end

  def parse_line(line) when is_binary(line), do: String.trim(line) |> String.graphemes()
  def parse_line(line), do: line

  def get_length(line) when is_binary(line), do: String.trim(line) |> String.length()
  def get_length(line), do: length(line)

  def tree?(line, {list, acc}) do
    tree = (Enum.at(line, rem(acc.i * 3, acc.length)) === @tree && 1) || 0
    acc = Map.put(acc, :i, acc.i + 1)

    {list + tree, acc}
  end
end
