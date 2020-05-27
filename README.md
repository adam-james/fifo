# Queue

A first-in-first-out queue data structure for Elixir. It wraps Erlang's
[:queue](https://erlang.org/doc/man/queue.html) in a more Elixir-friendly API.
It implements the `Inspect` protocol for pretty printing. It also implements the
`Enumerable` and `Collectable` protocols for working with collections. Functions
take a `Queue` as the first argument to allow for piping.

<!-- TODO -->
<!-- ## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `queue` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:queue, "~> 0.1.0"}
  ]
end
``` -->

## Basic Usage

```
iex(1)> queue = Queue.new
#Queue<[]>
iex(2)> queue = queue |> Queue.push(1) |> Queue.push(2)
#Queue<[1, 2]>
iex(3)> {_, queue} = Queue.pop(queue)
{{:value, 1}, #Queue<[2]>}
iex(4)> {_, queue} = Queue.pop(queue)
{{:value, 2}, #Queue<[]>}
iex(5)> {_, queue} = Queue.pop(queue)
{:empty, #Queue<[]>}
```

## Enumerable and Collectable

```
iex(37)> queue = Queue.new([1, 2])
#Queue<[1, 2]>
iex(38)> queue = Enum.into([3, 4], queue)
#Queue<[1, 2, 3, 4]>
iex(39)> squared = fn n -> n * n end
#Function<7.126501267/1 in :erl_eval.expr/5>
iex(40)> queue = Enum.map(queue, squared) |> Queue.new
#Queue<[1, 4, 9, 16]>
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).
Run `mix docs` to generate documentation locally.

## Benchmarks

Where there is more than one way to perform the same operation, I have included
benchmarks. These are located in the `bench` folder. You run them like this:

`mix run bench/<filename>.exs`

Often an alternative exists because there is a `Queue` implementation and an
`Enum` implementation. The `Queue` implementations may be faster because
they utilize the Erlang `:queue` library, which is optimized. For example,
`Queue.reverse/1` runs in constant time, `O(1)`, whereas `Enum.reverse/1` runs
in linear time, `O(n)`. See the benchmarks for more information.
