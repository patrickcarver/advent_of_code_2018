defmodule Day24.Part1 do
  alias FileLoader

  defmodule Group do
    defstruct [
      id: nil,
      units: 0,
      hit_points: 0,
      attack_damage: 0,
      attack_type: "",
      initiative: 0,
      weaknesses: [],
      immunities: [],
      army: nil,
      target: nil,
      is_targeted: false
    ]

    def effective_power(group) do
      group.units * group.attack_damage
    end

    defmodule Builder do
      def from(line, army) do
        {attack_damage, attack_type} = get_attack_info(line)

        %Group{
          id: make_ref(),
          units: get_units(line),
          hit_points: get_hit_points(line),
          attack_damage: attack_damage,
          attack_type: attack_type,
          initiative: get_initiative(line),
          weaknesses: get_weaknesses(line),
          immunities: get_immunities(line),
          army: army
        }
      end

      # refactor
      def get_weaknesses(line) do
        ~r/(?<=\().+(?=\))/
        |> Regex.run(line)
        |> (fn
            nil ->
              []
            str ->
              ~r/(?<=weak to ).*?(?=;|$)/
              |> Regex.run(hd(str))
              |> (
                fn
                  nil ->
                    []
                  result ->
                    result |> hd() |> String.split(", ")
                end).()
           end).()
      end

      # refactor
      def get_immunities(line) do
        ~r/(?<=\().+(?=\))/
        |> Regex.run(line)
        |> (fn
            nil ->
              []
            str ->
              ~r/(?<=immune to ).*?(?=;|$)/
              |> Regex.run(hd(str))
              |> (
                fn
                  nil ->
                    []
                  result ->
                    result |> hd() |> String.split(", ")
                end).()
           end).()
      end

      def get_units(line) do
        ~r/\d+(?= units)/
        |> Regex.run(line)
        |> hd()
        |> String.to_integer()
      end

      def get_hit_points(line) do
        ~r/\d+(?= hit points)/
        |> Regex.run(line)
        |> hd()
        |> String.to_integer()
      end

      def get_initiative(line) do
        ~r/(?<=initiative )\d+/
        |> Regex.run(line)
        |> hd()
        |> String.to_integer()
      end

      def get_attack_info(line) do
        ~r/\d+ \w+(?= damage)/
        |> Regex.run(line)
        |> hd()
        |> String.split(" ")
        |> (fn [damage, type] -> {String.to_integer(damage), type} end).()
      end
    end
  end

  def sort_by_initiative(list) do
    list
    |> Enum.sort(fn first, second -> first.initiative >= second.initiative end)
  end

  def sort_by_effective_power(list) do
    list
    |> Enum.sort(fn first, second -> Group.effective_power(first) >= Group.effective_power(second) end)
  end

  def select_targets(list) do

  end

  def fight(list) do
    list
    |> sort_by_initiative()
    |> sort_by_effective_power()
    |> select_targets()
  end

  def run(file_name) do
    file_name
    |> FileLoader.load()
    |> parse_data()
  end

  def parse_data(list) do
    list
    |> remove_empty_line()
    |> Enum.reduce(%{groups: [], current_army: nil}, &parse_line/2)
    |> Map.get(:groups)
  end

  def parse_line(line, acc) do
    case line do
      "Immune System:" ->
        set_current_army(acc, :immune_system)
      "Infection:" ->
        set_current_army(acc, :infection)
      _ ->
        group = Group.Builder.from(line, acc.current_army)
        update_in(acc.groups, & [group | &1])
    end
  end

  def set_current_army(acc, key) do
    Map.put(acc, :current_army, key)
  end

  def remove_empty_line(list) do
    Enum.reject(list, fn line -> line == "" end)
  end
end
