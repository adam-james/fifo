inputs = %{
  "small queues" => {FIFO.new(1..50), FIFO.new(51..100)},
  "medium queues" => {FIFO.new(1..5_000), FIFO.new(5_001..10_000)},
  "large queue" => {FIFO.new(1..500_000), FIFO.new(500_001..1_000_000)}
}

Benchee.run(
  %{
    "FIFO.join/2" => fn {queue1, queue2} -> FIFO.join(queue1, queue2) end,
    "Enum.concat/1" => fn {queue1, queue2} ->
      Enum.concat([queue1, queue2]) |> FIFO.from_list
    end 
  },
  inputs: inputs,
  memory_time: 1
)
