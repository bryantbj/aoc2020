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
    goal = 2020

    input = parse_input(input)

    input
    |> Stream.filter(fn i -> Enum.member?(input, goal - i) end)
    |> Enum.to_list()
    |> (fn [a, b] -> a * b end).()
  end

  def parse_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end
end
