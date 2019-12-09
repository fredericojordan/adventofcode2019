#!/usr/bin/env elixir
defmodule Day02 do
  defp run_opcode(1, code, pos) do
    arg_1 = code[code[pos+1]]
    arg_2 = code[code[pos+2]]
    dest_addr = code[pos+3]
    new_code = Map.put(code, dest_addr, arg_1+arg_2)

    {{new_code, pos+4}, {new_code, pos+4}}
  end

  defp run_opcode(2, code, pos) do
    arg_1 = code[code[pos+1]]
    arg_2 = code[code[pos+2]]
    dest_addr = code[pos+3]
    new_code = Map.put(code, dest_addr, arg_1*arg_2)

    {{new_code, pos+4}, {new_code, pos+4}}
  end

  defp run_opcode(99, _code, _pos), do: nil

  def run_program(code) do
    formatted_code =
      code
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {value, pos}, acc -> Map.put(acc, pos, value) end)

    final_code =
      {formatted_code, 0}
      |> Stream.unfold(fn {code, pos} -> run_opcode(code[pos], code, pos) end)
      |> Enum.to_list()
      |> Enum.take(-1)
      |> List.last()
      |> elem(0)

    Stream.unfold(0, fn
      x -> {Map.get(final_code, x), x+1}
    end)
    |> Enum.take_while(&(&1))
  end

  def program_value(code) do
    code
    |> run_program()
    |> List.first()
  end

  def program_value(code, noun, verb) do
    code
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> program_value()
  end

  defp generate_values(code) do
    for noun <- 0..99,
        verb <- 0..99, do:
                {program_value(code, noun, verb), noun, verb}
  end

  def search_value(code, expected_value) do
    generate_values(code)
    |> Enum.drop_while(fn {value, _n, _v} -> value != expected_value end)
    |> Enum.take(1)
    |> (fn [{_value, noun, verb}] -> 100*noun + verb end).()
  end

  def solve do
    run_program([1,0,0,0,99]) #== [2,0,0,0,99]
    run_program([2,3,0,3,99]) #== [2,3,0,6,99]
    run_program([2,4,4,5,99,0]) #== [2,4,4,5,99,9801]
    run_program([1,1,1,4,99,5,6,0,99]) #== [30,1,1,4,2,5,6,0,99]

    {:ok, input} = File.read("input02.txt")

    input_code =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    part_1_solution = program_value(input_code, 12, 2)

    IO.puts("Part 1: " <> Integer.to_string(part_1_solution))

    part_2_solution = search_value(input_code, 19690720)

    IO.puts("Part 2: " <> Integer.to_string(part_2_solution))
  end
end

Day02.solve
