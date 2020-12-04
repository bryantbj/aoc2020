defmodule Aoc2020 do
  @moduledoc """
  Documentation for Aoc2020.
  """

  @required_fields ~w[byr iyr eyr hgt hcl ecl pid]

  @doc """
  Takes the string +input+ and processes it.

  ## Examples
  iex> "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  iex> byr:1937 iyr:2017 cid:147 hgt:183cm
  iex>
  iex> iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  iex> hcl:#cfa07d byr:1929
  iex>
  iex> hcl:#ae17e1 iyr:2013
  iex> eyr:2024
  iex> ecl:brn pid:760753108 byr:1931
  iex> hgt:179cm
  iex>
  iex> hcl:#cfa07d eyr:2025 pid:166559648
  iex> iyr:2011 ecl:brn hgt:59in
  iex> " |> Aoc2020.run()
  2
  """
  def run(input) do
    input
    |> parse_input()
    |> Stream.filter(&passport_valid?/1)
    |> Enum.count()
  end

  def parse_input(input) when is_binary(input) do
    {:ok, input} = input |> StringIO.open()

    input
    |> IO.binstream(:line)
    |> parse_input()
  end

  def parse_input(input) do
    input
    |> Stream.chunk_by(&String.match?(&1, ~r/^\n$/))
    |> Stream.map(&Stream.map(&1, fn line -> String.trim(line) end))
    |> Stream.map(&Enum.join(&1, " "))
    |> Stream.filter(&(String.length(&1) > 0))
  end

  def passport_valid?(line) do
    @required_fields
    |> Stream.map(&String.match?(line, ~r/#{&1}/))
    |> Enum.all?()
  end
end
