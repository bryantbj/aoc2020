defmodule Aoc2020 do
  @goal 2020
  @moduledoc """
  Documentation for Aoc2020.
  """
  @doc """
  Takes the string +input+ and processes it.

  ## Examples
  iex> ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"] |> Aoc2020.run()
  2
  """
  def run(input) do
    parse_input(input)
    |> Stream.filter(&is_valid?/1)
    |> Enum.to_list()
    |> Enum.count()
  end

  def parse_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&detect_parts/1)
  end

  @doc """
  Splits a term into its policy and password parts

  ## Examples
  iex> "1-3 a: abcde" |> Aoc2020.detect_parts()
  {"a", 1, 3, "abcde"}
  """
  def detect_parts(str) do
    [min, max, char, password] =
      str
      |> String.split(~r/[\s:-]/)
      |> Enum.filter(&(String.length(&1) > 0))

    {char, String.to_integer(min), String.to_integer(max), password}
  end

  def is_valid?({char, min, max, pass}) do
    instances =
      pass
      |> String.graphemes()
      |> Enum.count(&(&1 == char))

    Enum.member?(min..max, instances)
  end
end
