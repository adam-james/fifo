# FIFO

A first-in-first-out queue data structure for Elixir. It wraps Erlang's
[:queue](https://erlang.org/doc/man/queue.html) in a more Elixir-friendly API.
It implements the `Inspect` protocol for pretty printing. It also implements the
`Enumerable` and `Collectable` protocols for working with collections. Functions
take a `FIFO` as the first argument to allow for piping.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fifo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fifo, "~> 0.1.0"}
  ]
end
```

## Basic Usage

```
iex(1)> queue = FIFO.new
#FIFO<[]>
iex(2)> queue = queue |> FIFO.push(1) |> FIFO.push(2)
#FIFO<[1, 2]>
iex(3)> {_, queue} = FIFO.pop(queue)
{{:value, 1}, #FIFO<[2]>}
iex(4)> {_, queue} = FIFO.pop(queue)
{{:value, 2}, #FIFO<[]>}
iex(5)> {_, queue} = FIFO.pop(queue)
{:empty, #FIFO<[]>}
```

## Enumerable and Collectable

```
iex(37)> queue = FIFO.new([1, 2])
#FIFO<[1, 2]>
iex(38)> queue = Enum.into([3, 4], queue)
#FIFO<[1, 2, 3, 4]>
iex(39)> squared = fn n -> n * n end
#Function<7.126501267/1 in :erl_eval.expr/5>
iex(40)> queue = Enum.map(queue, squared) |> FIFO.new
#FIFO<[1, 4, 9, 16]>
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).
Run `mix docs` to generate documentation locally.

## Benchmarks

Where there is more than one way to perform the same operation, I have included
benchmarks. These are located in the `bench` folder. You run them like this:

`mix run bench/<filename>.exs`

Often an alternative exists because there is a `FIFO` implementation and an
`Enum` implementation. The `FIFO` implementations may be faster because
they utilize the Erlang `:queue` library, which is optimized. For example,
`FIFO.reverse/1` runs in constant time, `O(1)`, whereas `Enum.reverse/1` runs
in linear time, `O(n)`. See the benchmarks for more information.
