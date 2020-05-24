# Queue

A first-in-first-out queue data structure for Elixir. Uses Erlang's `:queue`
library under the hood: https://erlang.org/doc/man/queue.html.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `queue` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:queue, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/queue](https://hexdocs.pm/queue).

## Benchmarks

Where there is more than one way to perform the same operation, I have included
benchmarks. These are located in the `bench` folder. You run them like this:

`mix run bench/<filename>.exs`

Often an alternative exists because there is a `Queue` implementation and an
`Enum` implementation. The `Queue` implementations are faster because they
utilize the Erlang `:queue` library, which is optimized. I recommend you use
the `Queue` implementations where they exist, e.g. `Queue.filter/2` instead of
`Enum.filter/2`.
