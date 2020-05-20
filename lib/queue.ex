defmodule Queue do
  @moduledoc """
  A wrapper around Erlang's `:queue` module. It only includes the Original API.
  There are two other APIs: the Extended API and the Okasaki API.

  - https://erlang.org/doc/man/queue.html#okasaki-api
  - https://erlang.org/doc/man/queue.html#extended-api
  """

  """
  #TODO debug this:
    iex(16)> Queue.from_list [7, 8, 9]
    #Queue<'\a\b\t'>
  """

  # TODO add type specs
  # TODO improve docs

  defstruct store: :queue.new()

  @doc """
  Returns an empty queue.

  ## Examples

      iex> Queue.new()
      #Queue<[]>

  """
  def new do
    :queue.new |> wrap_store
  end

  @doc """
  Returns a queue from a list.

  ## Examples

      iex> Queue.from_list([1,2,3])
      #Queue<[1, 2, 3]>

  """
  def from_list(list) when is_list(list) do
    list |> :queue.from_list |> wrap_store
  end

  @doc """
  Filters a queue.

  ## Examples

      iex> queue = Queue.from_list([1,2,3,4])
      iex> Queue.filter(queue, fn item -> rem(item, 2) != 0 end)
      #Queue<[1, 3]>

  """
  def filter(%Queue{store: store}, func) do
    store |> do_filter(func) |> wrap_store
  end

  defp do_filter(store, func) do
    :queue.filter(func, store)
  end

  @doc """
  Returns a list of items in a queue.

  ## Examples

      iex> queue = Queue.from_list([1, 2, 3, 4])
      iex> Queue.to_list(queue)
      [1, 2, 3, 4]

  """
  def to_list(%Queue{store: store}), do: :queue.to_list(store)

  @doc """
  Enqueues an item at the end of the queue. The Erlang library uses the name
  `in` for this function. This is not allowed in Elixir as `in` is a reserved word.
  For that reason, I have called this `in_l` for now. I am considering alternatives.

  ## Examples

      iex> queue = Queue.from_list([1, 2])
      iex> Queue.in_l(queue, 3)
      #Queue<[1, 2, 3]>

  """
  def in_l(%Queue{store: store}, item) do
    :queue.in(item, store) |> wrap_store
  end

  @doc """
  Enqueues an item at the front of the queue.

  ## Examples

      iex> queue = Queue.from_list([1, 2])
      iex> Queue.in_r(queue, 3)
      #Queue<[3, 1, 2]>

  """
  def in_r(%Queue{store: store}, item) do
    :queue.in_r(item, store) |> wrap_store
  end

  @doc """
  Returns `true` if the queue has not items. Returns `false` if the queue has items.

  ## Examples

      iex> queue = Queue.new
      iex> Queue.empty?(queue)
      true

      iex> queue = Queue.from_list([1])
      iex> Queue.empty?(queue)
      false

  """
  def empty?(%Queue{store: store}), do: :queue.is_empty(store)

  @doc """
  Returns `true` given value is a queue. Returns `false` if not. It also check the
  underlying implementation, ensuring the underlying implementation is also a queue.

  ## Examples

      iex> Queue.queue? Queue.new
      true

      iex> Queue.queue? []
      false

      iex> Queue.queue? %Queue{store: []}
      false

  """
  def queue?(%Queue{store: store}), do: :queue.is_queue(store)

  def queue?(_), do: false

  @doc """
  Returns a new queue which is a combination of `queue1` and `queue2`. `queue1`
  is in front for `queue2`.

  ## Examples

      iex> queue1 = Queue.from_list([1, 2])
      iex> queue2 = Queue.from_list([3, 4])
      iex> Queue.join(queue1, queue2)
      #Queue<[1, 2, 3, 4]>

  """
  def join(%Queue{store: store1}, %Queue{store: store2}) do
    :queue.join(store1, store2) |> wrap_store
  end

  @doc """
  Returns the length of the queue.

  ## Examples

      iex> queue = Queue.new
      iex> Queue.len(queue)
      0

      iex> queue = Queue.from_list([1, 2, 3])
      iex> Queue.len(queue)
      3

  """
  def len(%Queue{store: store}), do: :queue.len(store)

  @doc """
  Returns `true` if `item` matches a value in queue. Returns `false` if not.

  ## Examples

      iex> queue = Queue.from_list [1, 2, 3]
      iex> Queue.member?(queue, 2)
      true

      iex> queue = Queue.from_list [1, 2, 3]
      iex> Queue.member?(queue, 7)
      false

  """
  def member?(%Queue{store: store}, item), do: :queue.member(item, store)

  @doc """
  Removes item from the front of the queue.

  ## Examples

      iex> queue = Queue.from_list([1, 2])
      iex> {{:value, 1}, queue} = Queue.out(queue)
      iex> queue
      #Queue<[2]>

      iex> queue = Queue.new
      iex> {:empty, queue} = Queue.out(queue)
      iex> queue
      #Queue<[]>

  """
  def out(%Queue{store: store}) do
    store |> :queue.out |> handle_out
  end

  defp handle_out({{:value, item}, updated_store}) do
    {{:value, item}, wrap_store(updated_store)}
  end

  defp handle_out({:empty, updated_store}) do
    {:empty, wrap_store(updated_store)}
  end

  @doc """
  Returns an item from the end of the queue.

  ## Examples

      iex> queue = Queue.from_list [1, 2, 3]
      iex> {{:value, 3}, queue} = Queue.out_r(queue)
      iex> queue
      #Queue<[1, 2]>

      iex> queue = Queue.new
      iex> {:empty, queue} = Queue.out_r(queue)
      iex> queue
      #Queue<[]>

  """
  def out_r(%Queue{store: store}) do
    store |> :queue.out_r |> handle_out
  end

  @doc """
  Reverses a queue.

  ## Examples

      iex> queue = Queue.from_list [1, 2, 3]
      iex> Queue.reverse(queue)
      #Queue<[3, 2, 1]>

  """
  def reverse(%Queue{store: store}) do
    store |> :queue.reverse |> wrap_store
  end

  @doc """
  Splits a queue in two.

  ## Examples

      iex> queue = Queue.from_list [1, 2, 3]
      iex> {queue2, queue3} = Queue.split(queue, 1)
      iex> queue2
      #Queue<[1]>
      iex> queue3
      #Queue<[2, 3]>

  """
  def split(%Queue{store: store}, n) when n >= 0 do
    {store2, store3} = :queue.split(n, store)
    {wrap_store(store2), wrap_store(store3)}
  end

  defp wrap_store(store), do: %Queue{store: store}

  defimpl Inspect do
    def inspect(queue, _) do
      "#Queue<#{inspect(:queue.to_list(queue.store))}>"
    end
  end
end
