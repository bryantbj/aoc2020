defmodule Aoc2020Test do
  use ExUnit.Case, async: true
  doctest Aoc2020

  @tag :skip
  test "input works" do
    {File.stream!("data/input.txt"), "shiny gold"}
    |> Aoc2020.run()
    |> IO.inspect(label: "answer", limit: 2000)
  end
end
