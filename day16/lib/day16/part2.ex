defmodule Day16.Part2 do
  alias FileLoader

  defmodule Opcode do
    use Bitwise

    def get_functions() do
      :functions
      |> __MODULE__.__info__()
      |> Enum.map(fn {name, _arity} -> name end)
      |> Enum.reject(fn name -> name == :get_functions end)
    end

    # (add register) stores into register C the result of adding register A and register B.
    def addr(register, [a, b, c]) do
      %{register | c => register[a] + register[b]}
    end

    # (add immediate) stores into register C the result of adding register A and value B.
    def addi(register, [a, b, c]) do
      %{register | c => register[a] + b}
    end

    # (multiply register) stores into register C the result of multiplying register A and register B.
    def mulr(register, [a, b, c]) do
      %{register | c => register[a] * register[b]}
    end

    # (multiply immediate) stores into register C the result of multiplying register A and value B.
    def muli(register, [a, b, c]) do
      %{register | c => register[a] * b}
    end

    # (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    def banr(register, [a, b, c]) do
      %{register | c => band(register[a], register[b])}
    end

    # (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
    def bani(register, [a, b, c]) do
      %{register | c => band(register[a], b)}
    end

    # (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    def borr(register, [a, b, c]) do
      %{register | c => bor(register[a], register[b])}
    end

    # (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
    def bori(register, [a, b, c]) do
      %{register | c => bor(register[a], b)}
    end

    # (set register) copies the contents of register A into register C. (Input B is ignored.)
    def setr(register, [a, _b, c]) do
      %{register | c => register[a]}
    end

    # (set immediate) stores value A into register C. (Input B is ignored.)
    def seti(register, [a, _b, c]) do
      %{register | c => a}
    end

    # (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
    def gtir(register, [a, b, c]) do
      %{register | c => (if a > register[b], do: 1, else: 0)}
    end

    # (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
    def gtri(register, [a, b, c]) do
      %{register | c => (if register[a] > b, do: 1, else: 0)}
    end

    # (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
    def gtrr(register, [a, b, c]) do
      %{register | c => (if register[a] > register[b], do: 1, else: 0)}
    end

    # (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
    def eqir(register, [a, b, c]) do
      %{register | c => (if a == register[b], do: 1, else: 0)}
    end

    # (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    def eqri(register, [a, b, c]) do
      %{register | c => (if register[a] == b, do: 1, else: 0)}
    end

    # (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
    def eqrr(register, [a, b, c]) do
      %{register | c => (if register[a] == register[b], do: 1, else: 0)}
    end
  end

  def apply_opcodes(samples) do
    opcodes = Opcode.get_functions()

    Enum.map(samples, fn %{before: before, after: aftr, instruction: {opcode_num, instruction_list}  } ->
      Enum.reduce(opcodes, [], fn opcode_name, acc ->
        result = apply(Opcode, opcode_name, [before, instruction_list])
        if result == aftr, do: [{opcode_num, opcode_name} | acc], else: acc
      end)
    end)
  end

  def figure_out_opcode_nums([], found) do
    found |> Enum.into(%{})
  end

  def figure_out_opcode_nums(input, found) do
    singles = input |> Enum.filter(fn item -> length(item) == 1 end)
    [[{opcode, single_name}] | _rest] = singles

    new_found = [{opcode, single_name} | found]
    new_input =
      input
      |> Enum.map(fn sample ->
          Enum.reject(sample, fn {_, name} -> name == single_name end)
        end)
      |> Enum.reject(fn x -> x == [] end)

    figure_out_opcode_nums(new_input, new_found)
  end

  def get_opcode_lookup(file_name) do
    file_name
    |> load_samples()
    |> apply_opcodes()
    |> figure_out_opcode_nums([])
  end

  def process_test({registers, [], _opcode_lookup}) do
    registers
  end

  def process_test({registers, test_data, opcode_lookup}) do
    [{opcode, instruction_list} | rest_test_data] = test_data
    function_name = opcode_lookup[opcode]
    new_registers = apply(Opcode, function_name, [registers, instruction_list])

    process_test({new_registers, rest_test_data, opcode_lookup})
  end

  def run(file_name) do
    opcode_lookup = get_opcode_lookup(file_name)
    test_data = load_test("part2.txt")
    registers = %{0 => 0, 1 => 0, 2 => 0, 3 => 0}

    {registers, test_data, opcode_lookup}
    |> process_test()

  end

  def load_test(file_name) do
    file_name
    |> FileLoader.load()
    |> Enum.map(&parse_instruction_txt/1)
  end

  def load_samples(file_name) do
    file_name
    |> FileLoader.load()
    |> Enum.chunk_every(3,4)
    |> Enum.map(&parse_sample/1)
  end

  def parse_sample([before_txt, instruction_txt, after_txt]) do
    before_list = parse_register_text(before_txt)
    after_list = parse_register_text(after_txt)
    instruction = parse_instruction_txt(instruction_txt)

    %{
      before: before_list,
      after: after_list,
      instruction: instruction
    }
  end

  def parse_instruction_txt(text) do
    [opcode | instruction] = text |> String.split(" ") |> Enum.map(&String.to_integer/1)
    {opcode, instruction}
  end

  def parse_register_text(text) do
    text
    |> String.split(": ")
    |> List.last()
    |> Code.eval_string()
    |> elem(0)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {value, index}, acc -> Map.put(acc, index, value) end)
  end
end
