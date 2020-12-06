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
  11
  """
  def run(input) do
    input
    |> parse_input
    |> map_counts
    |> Enum.sum()
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
    |> Stream.map(&Enum.filter(&1, fn l -> String.match?(l, ~r/\w/) end))
    |> Stream.map(&Enum.uniq/1)
    |> Stream.map(&Enum.count/1)
  end
end
