
defmodule Day04.Part1 do
  # year-month-day hour:minute
  # guard id'ed "begins shift"
  # only midnight-hour minutes are relevant for asleep/awake times
    # guards might start duty on non-midnight hours
  # guards count as asleep the minute they fall asleep
  # guards count as awake the minute they wake up.
  # CHOOSE BEST GUARD / MINUTE combination
  # Strategy 1:
  #   a) Find guard with most sleep minutes
  #   b) what minute does that guard sleep the most?
  # ALSO: our input isn't in order. we need to sort that first

  alias Day04.Part1.{GuardRecordList, Processor, Answer}

  def run(file) do
    file
    |> GuardRecordList.read()
    |> Processor.process() # great name. seriously, the best.
    |> Answer.calculate()
  end
end
