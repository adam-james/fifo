inputs = %{
  "small queues" => {Queue.new(1..50), Queue.new(51..100)},
  "medium queues" => {Queue.new(1..5_000), Queue.new(5_001..10_000)},
  "large queue" => {Queue.new(1..500_000), Queue.new(500_001..1_000_000)}
}

Benchee.run(
  %{
    "Queue.join/2" => fn {queue1, queue2} -> Queue.join(queue1, queue2) end,
    "Enum.concat/1" => fn {queue1, queue2} ->
      Enum.concat([queue1, queue2]) |> Queue.from_list
    end 
  },
  inputs: inputs,
  memory_time: 1
)
