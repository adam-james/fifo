inputs = %{
  "small queue" => FIFO.new(1..100),
  "medium queue" => FIFO.new(1..10_000),
  "large queue" => FIFO.new(1..1_000_000)
}

Benchee.run(%{
  "FIFO.reverse" => fn queue -> FIFO.reverse(queue) end,
  "Enum.reverse" => fn queue -> Enum.reverse(queue) |> FIFO.from_list end
},
  inputs: inputs,
  memory_time: 1
)
