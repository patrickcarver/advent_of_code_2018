defmodule Day16.Part1 do
  alias FileLoader

  defmodule Opcode do
    use Bitwise

    # [0] [1] [2] [3]
    # (add register) stores into register C the result of adding register A and register B.
    def addr(register, [_opcode, a, b, c]) do
      %{register | c => register[a] + register[b]}
    end

    # (add immediate) stores into register C the result of adding register A and value B.
    def addi(register, [_opcode, a, b, c]) do
      %{register | c => register[a] + b}
    end

    # (multiply register) stores into register C the result of multiplying register A and register B.
    def mulr(register, [_opcode, a, b, c]) do
      %{register | c => register[a] * register[b]}
    end

    # (multiply immediate) stores into register C the result of multiplying register A and value B.
    def muli(register, [_opcode, a, b, c]) do
      %{register | c => register[a] * b}
    end

    # (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    def banr(register, [_opcode, a, b, c]) do
      %{register | c => band(register[a], register[b])}
    end

    # (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
    def bani(register, [_opcode, a, b, c]) do
      %{register | c => band(register[a], b)}
    end

    # (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    def borr(register, [_opcode, a, b, c]) do
      %{register | c => bor(register[a], register[b])}
    end

    # (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
    def bori(register, [_opcode, a, b, c]) do
      %{register | c => bor(register[a], b)}
    end

    # (set register) copies the contents of register A into register C. (Input B is ignored.)
    def setr(register, [_opcode, a, _b, c]) do
      %{register | c => register[a]}
    end

    # (set immediate) stores value A into register C. (Input B is ignored.)
    def seti(register, [_opcode, a, _b, c]) do
      %{register | c => a}
    end

    # (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
    def gtir(register, [_opcode, a, b, c]) do
      %{register | c => (if a > register[b], do: 1, else: 0)}
    end

    # (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
    def gtri(register, [_opcode, a, b, c]) do
      %{register | c => (if register[a] > b, do: 1, else: 0)}
    end

    # (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
    def gtrr(register, [_opcode, a, b, c]) do
      %{register | c => (if register[a] > register[b], do: 1, else: 0)}
    end

    # (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
    def eqir(register, [_opcode, a, b, c]) do
      %{register | c => (if a == register[b], do: 1, else: 0)}
    end

    # (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    def eqri(register, [_opcode, a, b, c]) do
      %{register | c => (if register[a] == b, do: 1, else: 0)}
    end

    # (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
    def eqrr(register, [_opcode, a, b, c]) do
      %{register | c => (if register[a] == register[b], do: 1, else: 0)}
    end
  end

  def run(file_name) do
    file_name
    |> load_samples()
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
    instruction_list = parse_instruction_txt(instruction_txt)

    %{
      before: before_list,
      after: after_list,
      instruction: instruction_list
    }
  end

  def parse_instruction_txt(text) do
    text
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
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
