defmodule Aoc2020 do
  @moduledoc """
  Documentation for Aoc2020.
  """

  @required_fields ~w[byr iyr eyr hgt hcl ecl pid]
  @valid_ecl MapSet.new(~w[amb blu brn gry grn hzl oth])

  @doc """
  Takes the string +input+ and processes it.

  ## Examples
  iex> "eyr:1972 cid:100
  iex> hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
  iex>
  iex> iyr:2019
  iex> hcl:#602927 eyr:1967 hgt:170cm
  iex> ecl:grn pid:012533040 byr:1946
  iex>
  iex> hcl:dab227 iyr:2012
  iex> ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
  iex>
  iex> hgt:59cm ecl:zzz
  iex> eyr:2038 hcl:74454a iyr:2023
  iex> pid:3556412378 byr:2007
  iex>
  iex> pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
  iex> hcl:#623a2f
  iex>
  iex> eyr:2029 ecl:blu cid:129 byr:1989
  iex> iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
  iex>
  iex> hcl:#888785
  iex> hgt:164cm byr:2001 iyr:2015 cid:88
  iex> pid:545766238 ecl:hzl
  iex> eyr:2022
  iex>
  iex> iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
  iex> " |> Aoc2020.run()
  4
  """
  def run(input) do
    input
    |> parse_input()
    |> Stream.filter(&passport_valid?/1)
    |> Enum.to_list()
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
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(String.length(&1) > 0))
  end

  def passport_valid?(line) do
    required = has_required_fields?(line)
    valid = fields_are_valid?(line)

    required && valid
  end

  def has_required_fields?(line) do
    @required_fields
    |> Stream.map(&String.match?(line, ~r/#{&1}/))
    |> Enum.all?()
  end

  def fields_are_valid?(line) do
    line
    |> String.split(~r/\s/, trim: true)
    |> Stream.filter(fn str -> Enum.member?(@required_fields, String.slice(str, 0..2)) end)
    |> Enum.to_list()
    |> Stream.map(&field_valid?/1)
    |> Enum.all?()
  end

  def year_validator(val, range) do
    [val]
    |> Stream.filter(&(String.length(&1) == 4))
    |> Stream.map(&(String.to_integer(&1) in range))
    |> Enum.any?()
  end

  def field_valid?("byr:" <> val), do: year_validator(val, 1920..2002)
  def field_valid?("iyr:" <> val), do: year_validator(val, 2010..2020)
  def field_valid?("eyr:" <> val), do: year_validator(val, 2020..2030)

  def field_valid?("hgt:" <> val) do
    case String.match?(val, ~r/\d+(?:in|cm)/) do
      false ->
        false

      _ ->
        num =
          Regex.scan(~r/\d+/, val)
          |> List.flatten()
          |> Enum.at(0)
          |> (fn n -> n && String.to_integer(n) end).()

        case String.match?(val, ~r/cm/) do
          true ->
            num in 150..193

          _ ->
            num in 59..76
        end
    end
  end

  def field_valid?("hcl:#" <> val) do
    String.match?(val, ~r/[0-9a-f]{6}/)
  end

  def field_valid?("hcl:" <> _val), do: false

  def field_valid?("ecl:" <> val) do
    @valid_ecl
    |> MapSet.member?(val)
  end

  def field_valid?("pid:" <> val) do
    String.match?(val, ~r/^\d{9}$/)
  end

  def field_valid?("cid:" <> _val), do: true
end
