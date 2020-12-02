defmodule Aoc2020Test do
  use ExUnit.Case, async: true
  doctest Aoc2020

  @tag :skip
  test "1a input works" do
    answer = File.stream!("data/1.txt") |> Aoc2020.expense_report()
    IO.inspect(answer)
  end
end
