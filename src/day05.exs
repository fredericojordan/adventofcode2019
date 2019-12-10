#!/usr/bin/env elixir
defmodule Day05 do
  defp run_opcode(raw_opcode, code, pos) do
    opcode = rem(raw_opcode, 100)
    bitmask = div(raw_opcode, 100)

    run_opcode(opcode, code, pos, bitmask)
  end

  defp run_opcode(1, code, pos, bitmask) do
    arg_1 = get_arg1(code, pos, bitmask)
    arg_2 = get_arg2(code, pos, bitmask)
    dest_addr = code[pos+3]
    new_code = Map.put(code, dest_addr, arg_1+arg_2)

    {{new_code, pos+4}, {new_code, pos+4}}
  end

  defp run_opcode(2, code, pos, bitmask) do
    arg_1 = get_arg1(code, pos, bitmask)
    arg_2 = get_arg2(code, pos, bitmask)
    dest_addr = code[pos+3]
    new_code = Map.put(code, dest_addr, arg_1*arg_2)

    {{new_code, pos+4}, {new_code, pos+4}}
  end

  defp run_opcode(3, code, pos, _bitmask) do
    dest_addr = code[pos+1]
    input =
      IO.gets("Please input the ID of the system to test: ")
      |> String.trim()
      |> String.to_integer()
    new_code = Map.put(code, dest_addr, input)

    {{new_code, pos+2}, {new_code, pos+2}}
  end

  defp run_opcode(4, code, pos, bitmask) do
    IO.inspect(get_arg1(code, pos, bitmask))

    {{code, pos+2}, {code, pos+2}}
  end

  defp run_opcode(5, code, pos, bitmask) do
    jump? = get_arg1(code, pos, bitmask) != 0
    new_pos = get_arg2(code, pos, bitmask)

    jump_if(code, pos, new_pos, jump?)
  end

  defp run_opcode(6, code, pos, bitmask) do
    jump? = get_arg1(code, pos, bitmask) == 0
    new_pos = get_arg2(code, pos, bitmask)

    jump_if(code, pos, new_pos, jump?)
  end

  defp run_opcode(7, code, pos, bitmask) do
    write? = get_arg1(code, pos, bitmask) < get_arg2(code, pos, bitmask)
    dest_addr = code[pos+3]
    new_code = write_if(code, dest_addr, write?)

    {{new_code, pos+4}, {new_code, pos+4}}
  end

  defp run_opcode(8, code, pos, bitmask) do
    write? = get_arg1(code, pos, bitmask) == get_arg2(code, pos, bitmask)
    dest_addr = code[pos+3]
    new_code = write_if(code, dest_addr, write?)

    {{new_code, pos+4}, {new_code, pos+4}}
  end

  defp run_opcode(99, _code, _pos, _bitmask), do: nil

  defp jump_if(code, _pos, new_pos, :true), do: {{code, new_pos}, {code, new_pos}}
  defp jump_if(code, pos, _new_pos, :false), do: {{code, pos+3}, {code, pos+3}}

  defp write_if(code, dest_addr, :true), do: Map.put(code, dest_addr, 1)
  defp write_if(code, dest_addr, :false), do: Map.put(code, dest_addr, 0)


  def run_program(code) do
    opcode_map = opcode_list_to_map(code)

    final_code =
      {opcode_map, 0}
      |> Stream.unfold(fn {code, pos} -> run_opcode(code[pos], code, pos) end)
      |> Enum.to_list()
      |> Enum.take(-1)
      |> List.last()
      |> elem(0)

    opcode_map_to_list(final_code)
  end

  def opcode_list_to_map(opcodes) do
    opcodes
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {value, pos}, acc -> Map.put(acc, pos, value) end)
  end

  def opcode_map_to_list(map) do
    Stream.unfold(0, fn
      x -> {Map.get(map, x), x+1}
    end)
    |> Enum.take_while(&(&1))
  end

  def get_arg(code, pos, 0), do: code[code[pos]]
  def get_arg(code, pos, 1), do: code[pos]

  def get_arg1(code, pos, bitmask), do: get_arg(code, pos+1, rem(bitmask, 10))

  def get_arg2(code, pos, bitmask), do: get_arg(code, pos+2, rem(div(bitmask, 10), 10))

  def solve do
    {:ok, input} = File.read("input05.txt")

    input_code =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    IO.puts("Part 1: (system ID 1)")
    run_program(input_code)
    IO.puts("")

    IO.puts("Part 2: (system ID 5)")
    run_program(input_code)
    IO.puts("")
  end

end

Day05.solve
