defmodule Queue do
  @moduledoc """
  A wrapper around Erlang's `:queue` module. It only includes the Original API.
  There are two other APIs: the Extended API and the Okasaki API.

  - https://erlang.org/doc/man/queue.html#okasaki-api
  - https://erlang.org/doc/man/queue.html#extended-api
  """

  @opaque queue :: %__MODULE__{store: :queue.queue()}
  @type t :: queue

  # TODO
  # - pare down API
  # - improve docs
  # - property based testing?

  defstruct store: :queue.new()

  @doc """
  Returns an empty queue.

  ## Examples

      iex> Queue.new()
      #Queue<[]>

  """
  @spec new :: t
  def new do
    :queue.new() |> wrap_store
  end

  defp wrap_store(store), do: %Queue{store: store}

  @doc """
  Creates a queue from an enumerable.

  ## Examples

      iex> Queue.new([1, 2, 3])
      #Queue<[1, 2, 3]>

  """
  @spec new(Enum.t()) :: t
  def new(enumerable) do
    Enum.into(enumerable, Queue.new())
  end

  @doc """
  Creates a queue from an enumerable via the transformation function.

  ## Examples

      iex> Queue.new([1, 2, 3], fn n -> n * n end)
      #Queue<[1, 4, 9]>

  """
  @spec new(Enum.t(), (term -> term)) :: t
  def new(enumerable, transform) do
    enumerable
    |> Enum.map(transform)
    |> Enum.into(Queue.new())
  end

  @doc """
  Returns a queue from a list.

  ## Examples

      iex> Queue.from_list([1,2,3])
      #Queue<[1, 2, 3]>

  """
  @spec from_list(list) :: t
  def from_list(list) when is_list(list) do
    list |> :queue.from_list() |> wrap_store
  end

  @doc """
  Filters a queue.

  ## Examples

      iex> queue = Queue.from_list([1,2,3,4])
      iex> Queue.filter(queue, fn item -> rem(item, 2) != 0 end)
      #Queue<[1, 3]>

  """
  @spec filter(t, (term -> boolean)) :: t
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
  @spec to_list(t) :: list
  def to_list(%Queue{store: store}), do: :queue.to_list(store)

  @doc """
  Enqueues an item at the end of the queue.

  ## Examples

      iex> queue = Queue.from_list([1, 2])
      iex> Queue.push(queue, 3)
      #Queue<[1, 2, 3]>

  """
  @spec push(t, term) :: t
  def push(%Queue{store: store}, item) do
    :queue.in(item, store) |> wrap_store
  end

  @doc """
  Enqueues an item at the front of the queue.

  ## Examples

      iex> queue = Queue.from_list([1, 2])
      iex> Queue.push_r(queue, 3)
      #Queue<[3, 1, 2]>

  """
  @spec push_r(t, term) :: t
  def push_r(%Queue{store: store}, item) do
    :queue.in_r(item, store) |> wrap_store
  end

  @doc """
  Returns `true` if the queue has no items. Returns `false` if the queue has items.

  ## Examples

      iex> queue = Queue.new
      iex> Queue.empty?(queue)
      true

      iex> queue = Queue.from_list([1])
      iex> Queue.empty?(queue)
      false

  """
  @spec empty?(t) :: boolean
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
  @spec queue?(t) :: boolean
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
  @spec join(t, t) :: t
  def join(%Queue{store: store1}, %Queue{store: store2}) do
    :queue.join(store1, store2) |> wrap_store
  end

  @doc """
  Returns the length of the queue.

  ## Examples

      iex> queue = Queue.new
      iex> Queue.size(queue)
      0

      iex> queue = Queue.from_list([1, 2, 3])
      iex> Queue.size(queue)
      3

  """
  @spec size(t) :: non_neg_integer
  def size(%Queue{store: store}), do: :queue.len(store)

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
  @spec member?(t, term) :: boolean
  def member?(%Queue{store: store}, item), do: :queue.member(item, store)

  @type tagged_value(term) :: {:value, term}
  @type value_out :: {tagged_value(term), t}
  @type empty_out :: {:empty, t}

  @doc """
  Removes item from the front of the queue.

  ## Examples

      iex> queue = Queue.from_list([1, 2])
      iex> {{:value, 1}, queue} = Queue.pop(queue)
      iex> queue
      #Queue<[2]>

      iex> queue = Queue.new
      iex> {:empty, queue} = Queue.pop(queue)
      iex> queue
      #Queue<[]>

  """
  @spec pop(t) :: value_out | empty_out
  def pop(%Queue{store: store}) do
    store |> :queue.out() |> handle_pop
  end

  defp handle_pop({{:value, item}, updated_store}) do
    {{:value, item}, wrap_store(updated_store)}
  end

  defp handle_pop({:empty, updated_store}) do
    {:empty, wrap_store(updated_store)}
  end

  @doc """
  Returns an item from the end of the queue.

  ## Examples

      iex> queue = Queue.from_list [1, 2, 3]
      iex> {{:value, 3}, queue} = Queue.pop_r(queue)
      iex> queue
      #Queue<[1, 2]>

      iex> queue = Queue.new
      iex> {:empty, queue} = Queue.pop_r(queue)
      iex> queue
      #Queue<[]>

  """
  @spec pop_r(t) :: value_out | empty_out
  def pop_r(%Queue{store: store}) do
    store |> :queue.out_r() |> handle_pop
  end

  @doc """
  Reverses a queue.

  ## Examples

      iex> queue = Queue.from_list [1, 2, 3]
      iex> Queue.reverse(queue)
      #Queue<[3, 2, 1]>

  """
  @spec reverse(t) :: t
  def reverse(%Queue{store: store}) do
    store |> :queue.reverse() |> wrap_store
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
  @spec split(t, integer) :: {t, t}
  def split(%Queue{store: store}, n) when n >= 0 do
    {store2, store3} = :queue.split(n, store)
    {wrap_store(store2), wrap_store(store3)}
  end

  defimpl Enumerable do
    def count(queue) do
      {:ok, Queue.len(queue)}
    end

    def member?(queue, val) do
      {:ok, Queue.member?(queue, val)}
    end

    def slice(queue) do
      size = Queue.len(queue)
      {:ok, size, &Enumerable.List.slice(Queue.to_list(queue), &1, &2, size)}
    end

    def reduce(queue, acc, fun) do
      Enumerable.List.reduce(Queue.to_list(queue), acc, fun)
    end
  end

  defimpl Collectable do
    def into(queue) do
      fun = fn
        list, {:cont, x} -> [x | list]
        list, :done -> Queue.join(queue, Queue.from_list(Enum.reverse(list)))
        _, :halt -> :ok
      end

      {[], fun}
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(queue, opts) do
      opts = %Inspect.Opts{opts | charlists: :as_lists}
      concat(["#Queue<", Inspect.List.inspect(Queue.to_list(queue), opts), ">"])
    end
  end
end
