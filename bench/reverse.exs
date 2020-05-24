inputs = %{
  "small queue" => Queue.new(1..100),
  "medium queue" => Queue.new(1..10_000),
  "large queue" => Queue.new(1..1_000_000)
}

Benchee.run(%{
  "Queue.reverse" => fn queue -> Queue.reverse(queue) end,
  "Enum.reverse" => fn queue -> Enum.reverse(queue) |> Queue.from_list end
},
  inputs: inputs,
  memory_time: 1
)
