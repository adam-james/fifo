inputs = %{
  "small list" => Enum.into(1..100, []),
  "medium list" => Enum.into(1..10_000, []),
  "large list" => Enum.into(1..1_000_000, [])
}

Benchee.run(%{
  ":queue.from_list" => fn list -> :queue.from_list(list) end,
  "FIFO.from_list" => fn list -> FIFO.from_list(list) end,
  "FIFO.new" => fn list -> FIFO.new(list) end
},
  inputs: inputs,
  memory_time: 1
)
