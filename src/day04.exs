#!/usr/bin/env elixir
defmodule Day04 do
  def count_valid(range_start, range_end) do
    range_start..range_end
    |> Stream.filter(&increases?/1)
    |> Stream.filter(&has_doubles?/1)
    |> Enum.count()
  end

  def count_strictly_valid(range_start, range_end) do
    range_start..range_end
    |> Stream.filter(&increases?/1)
    |> Stream.filter(&has_strict_doubles?/1)
    |> Enum.count()
  end

  def increases?(number) do
    number
    |> Integer.digits()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a,b] -> b-a >= 0 end)
  end

  def has_doubles?(number) do
    number
    |> Integer.digits()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [a,b] -> a == b end)
  end

  def has_strict_doubles?(number) do
    number
    |> Integer.digits()
    |> Enum.chunk_by(&(&1))
    |> Enum.any?(&(Enum.count(&1) == 2))
  end

  def solve do
    {:ok, input} = File.read("input04.txt")

    [range_start, range_end] =
      input
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)


    part_1_solution = count_valid(range_start, range_end)
    IO.puts("Part 1: " <> Integer.to_string(part_1_solution))

    part_2_solution = count_strictly_valid(range_start, range_end)
    IO.puts("Part 2: " <> Integer.to_string(part_2_solution))
  end
end

Day04.solve
