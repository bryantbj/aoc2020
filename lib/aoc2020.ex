defmodule Aoc2020 do
  @moduledoc """
  Documentation for Aoc2020.
  """
  @doc """
  Takes the string +input+ and processes it.

  ## Examples
  iex> {"light red bags contain 1 bright white bag, 2 muted yellow bags.
  iex> dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  iex> bright white bags contain 1 shiny gold bag.
  iex> muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  iex> shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  iex> dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  iex> vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  iex> faded blue bags contain no other bags.
  iex> dotted black bags contain no other bags.", "shiny gold"} |> Aoc2020.run()
  4
  """
  def run(input \\ nil)

  def run(nil) do
    Path.expand("../data/input.txt", __DIR__)
    |> File.read!()
    |> (&{&1, "shiny gold"}).()
    |> run()
  end

  def run({input, bag}) do
    input
    |> parse_input
    |> map_stream_parts()
    |> build_graph()
    |> analyze_graph(bag)
    |> IO.inspect()
  end

  def run_to_build({input, bag}) do
    input
    |> parse_input
    |> map_stream_parts()
    |> build_graph()
  end

  def doctest_input_run() do
    "light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags."
  end

  def test() do
    {doctest_input_run(), "shiny gold"}
    |> run_to_build()
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
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(String.length(&1) > 0))
  end

  def map_stream_parts(stream) do
    stream
    |> Stream.map(&Regex.scan(~r/[\w\s]+?bags?/, &1))
    |> Stream.map(&List.flatten/1)
    |> Stream.map(&map_line_parts/1)
  end

  def map_line_parts(list) do
    # Turns a given line into {key, [{bag, num}, {bag2, num}]}
    line_to_parts = fn [key | list] ->
      {sanitize_key(key), Enum.map(list, &relationships/1)}
    end

    list
    |> Stream.map(&String.replace(&1, ~r/contains?/, ""))
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
    |> line_to_parts.()
  end

  @doc """
  iex> Aoc2020.sanitize_key("shiny gold bag")
  "shiny gold"
  """
  def sanitize_key(key) do
    key |> String.split("bag") |> Enum.at(0) |> String.trim()
  end

  def relationships(line) do
    part_regex = ~r/(\d+?)([\w\s]+)bag/

    case Regex.scan(part_regex, line) |> List.flatten() do
      [_, num, desc] ->
        {String.trim(desc), String.to_integer(num)}

      _ ->
        nil
    end
  end

  def build_graph(stream) do
    stream
    |> Stream.scan(Graph.new(), fn {key, rels}, graph ->
      Enum.reduce(rels, graph, fn
        {rel_key, _count}, g ->
          Graph.add_edge(g, key, rel_key)

        nil, g ->
          g
      end)
    end)
    |> Enum.reverse()
    |> hd
  end

  def list_contains_bag?(nil, _bag), do: nil
  def list_contains_bag?({key, _}, bag), do: key == bag

  def analyze_graph(graph, bag) do
    graph
    |> Graph.vertices()
    |> Enum.reduce([], fn el, acc -> [Graph.get_paths(graph, el, bag) | acc] end)
    |> Util.flatten(1)
    |> Enum.map(&hd/1)
    |> Enum.uniq()
    |> Enum.count()
  end
end
