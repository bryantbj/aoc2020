defmodule Aoc2020 do
  @moduledoc """
  Documentation for Aoc2020.
  """
  @doc """
  Takes the string +input+ and processes it.

  ## Examples
  iex>"abc
  iex>
  iex> a
  iex> b
  iex> c
  iex>
  iex> ab
  iex> ac
  iex>
  iex> a
  iex> a
  iex> a
  iex> a
  iex>
  iex> b" |> Aoc2020.run()
  6
  """
  def run(input) do
    input
    |> parse_input
    |> map_counts
    |> IO.inspect()
  end

  def parse_input(input) when is_binary(input) do
    {:ok, input} = StringIO.open(input)

    input
    |> IO.binstream(:line)
    |> parse_input()
  end

  @doc """
  Takes input and massages it a bit. Separates records, removes empty strings, etc.
  """
  def parse_input(input) do
    input
    |> Stream.chunk_by(&String.match?(&1, ~r/^\n$/))
    |> Stream.map(&Stream.map(&1, fn l -> String.trim(l) end))
    |> Stream.map(&Enum.join(&1, " "))
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(String.length(&1) > 0))
  end

  def map_counts(stream) do
    stream
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&Enum.chunk_by(&1, fn i -> String.match?(i, ~r/\w+/) end))
    |> Stream.map(&count_unanimous_yes/1)
    |> Enum.sum()
  end

  @doc """
  Accepts a list of lists and counts the number of times everyone
  in the group agreed on an answer

  ## Examples
  iex> [~w[a b c]] |> Aoc2020.count_unanimous_yes()
  3

  iex> [["a"], ["b"], ["c"]] |> Aoc2020.count_unanimous_yes()
  0

  iex> [~w[a b], ~w[a c]] |> Aoc2020.count_unanimous_yes()
  1
  """
  def count_unanimous_yes(list) do
    list = Enum.filter(list, &(Enum.join(&1, "") |> String.match?(~r/\w+/)))
    master_list = list |> List.flatten() |> Enum.uniq() |> Enum.filter(&String.match?(&1, ~r/\w/))

    Enum.reduce(master_list, MapSet.new(), fn l, set ->
      if Enum.all?(list, &Enum.member?(&1, l)) do
        MapSet.put(set, l)
      else
        set
      end
    end)
    |> Enum.count()
  end
end
