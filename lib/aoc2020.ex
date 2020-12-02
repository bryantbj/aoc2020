defmodule Aoc2020 do
  @moduledoc """
  Documentation for Aoc2020.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc2020.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  Takes the string +input+ and processes it.

  ## Examples
  iex> ~w[1721 979 366 299 675 1456] |> Aoc2020.expense_report()
  514579
  """
  def expense_report(input) do
    input = parse_input(input)

    input
    |> Stream.map(&add(&1, input))
    |> Stream.filter(fn {_i, list} -> Enum.find(list, &(&1 == 2020)) end)
    |> Enum.to_list()
    |> select()
  end

  def parse_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def add(int, list) do
    {int, Enum.filter(list, &(&1 !== int)) |> Enum.map(&(&1 + int))}
  end

  def add_again(int1, {int2, list}) do
    {int1, Enum.filter(list, &(&1 !== int1 && &1 !== int2)) |> Enum.map(&(&1 + int2))}
  end

  def select([{a, _}, {b, _}]) do
    a * b
  end
end
