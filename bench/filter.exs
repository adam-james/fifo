even = fn n -> rem(n, 2) == 0 end

inputs = %{
  "small queue" => Queue.new(1..100),
  "medium queue" => Queue.new(1..10_000),
  "large queue" => Queue.new(1..1_000_000)
}

Benchee.run(
  %{
    "Queue.filter" => fn queue -> Queue.filter(queue, even) end,
    "Enum.filter" => fn queue -> Enum.filter(queue, even) |> Queue.from_list end
  },
  inputs: inputs,
  memory_time: 1
)
