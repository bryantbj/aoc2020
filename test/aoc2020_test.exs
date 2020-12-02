defmodule Aoc2020Test do
  use ExUnit.Case, async: true
  doctest Aoc2020

  @tag :skip
  test "input works" do
    File.stream!("data/input.txt") |> Aoc2020.run() |> IO.inspect(label: "answer")
  end
end
