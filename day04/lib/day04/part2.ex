defmodule Day04.Part2 do

  alias Day04.Part1.{GuardRecordList, Processor}
  alias Day04.Part2.Answer

  def run(file) do
    file
    |> GuardRecordList.read()
    |> Processor.process() # great name. seriously, the best.
    |> Answer.calculate()
  end
end
