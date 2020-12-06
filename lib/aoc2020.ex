defmodule Aoc2020 do
  @moduledoc """
  Documentation for Aoc2020.
  """
  @doc """
  Takes the string +input+ and processes it.
  """
  def run(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&find_seat/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> find_missing_seat()
  end

  @doc """
  Takes a string and returns the seat ID

  ## Exampleso
  iex> "FBFBBFFRLR" |> Aoc2020.find_seat()
  357

  iex> "BFFFBBFRRR" |> Aoc2020.find_seat()
  567

  iex> "FFFBBBFRRR" |> Aoc2020.find_seat()
  119

  iex> "BBFFBBFRLL" |> Aoc2020.find_seat()
  820
  """
  def find_seat(str) do
    [_, rows, columns] = Regex.scan(~r/(\w{7})(\w{3})/, str) |> List.flatten()

    row = find_row(rows)
    column = find_column(columns)

    row * 8 + column
  end

  @doc """
  Finds the row specified on the ticket

  ## Examples
  iex> Aoc2020.find_row("FBFBBFF")
  44
  """
  def find_row(row) do
    row
    |> String.graphemes()
    |> Enum.reduce({127, 6}, &move/2)
    |> (fn {n, _} -> n end).()
  end

  @doc """
  Finds the column specified on the ticket

  ## Examples
  iex> Aoc2020.find_column("RLR")
  5
  """
  def find_column(columns) do
    columns
    |> String.graphemes()
    |> Enum.reduce({7, 2}, &move/2)
    |> (fn {n, _} -> n end).()
  end

  @doc """
  Take the "front" half

  ## Examples
  iex> Aoc2020.move("F", {127, 6})
  {63, 5}

  iex> Aoc2020.move("B", {63, 5})
  {63, 4}
  """
  def move("F", {previous, power}) do
    {(previous - :math.pow(2, power)) |> round, power - 1}
  end

  # this is basically an "F" move
  def move("L", acc), do: move("F", acc)

  def move("B", {previous, power}) do
    {previous, power - 1}
  end

  # this is basically a "B" move
  def move("R", acc), do: move("B", acc)

  def find_missing_seat(list) do
    list
    |> Stream.chunk_every(3, 1)
    |> Stream.filter(fn list -> Enum.at(list, 0) - Enum.at(list, 1) !== 1 end)
    |> Enum.to_list()
    |> hd()
    |> (&(hd(&1) - 1)).()
  end
end
