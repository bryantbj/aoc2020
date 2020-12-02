defmodule Aoc2020 do
  @goal 2020
  @moduledoc """
  Documentation for Aoc2020.
  """
  @doc """
  Takes the string +input+ and processes it.

  ## Examples
  iex> ~w[1721 979 366 299 675 1456] |> Aoc2020.expense_report()
  241861950
  """
  def expense_report(input) do
    input = parse_input(input)

    input
    |> find_nums()
  end

  def parse_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end

  def find_nums(input) do
    Enum.reduce(input, %{vals: [], solved: %{}, input: input}, fn i, outer_acc ->
      Enum.reduce(input, outer_acc, fn j, acc ->
        cond do
          # never use the same number twice in the equation
          i == j ->
            acc

          # use a map to ensure we don't duplicate efforts
          Map.has_key?(acc.solved, Enum.sort([i, j])) ->
            acc

          true ->
            val = @goal - i - j
            # add this value to the +solved+ map
            acc = put_in(acc, [:solved], Map.put(acc.solved, Enum.sort([i, j]), val))

            # is the answer a member of +input+? if so, add it to +vals+
            (Enum.member?(input, val) && Map.put(acc, :vals, [val | acc.vals])) || acc
        end
      end)
    end)
    |> Map.get(:vals)
    |> Enum.uniq()
    |> Enum.reduce(1, fn i, acc -> acc * i end)
  end
end
