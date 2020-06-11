even = fn n -> rem(n, 2) == 0 end

inputs = %{
  "small queue" => FIFO.new(1..100),
  "medium queue" => FIFO.new(1..10_000),
  "large queue" => FIFO.new(1..1_000_000)
}

Benchee.run(
  %{
    "FIFO.filter" => fn queue -> FIFO.filter(queue, even) end,
    "Enum.filter" => fn queue -> Enum.filter(queue, even) |> FIFO.from_list end
  },
  inputs: inputs,
  memory_time: 1
)
