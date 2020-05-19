defmodule Queue do
  @moduledoc """
  A wrapper around Erlang's `:queue` module.
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
  def from_list(list) do
    list |> :queue.from_list |> wrap_store
  end

  @doc """
  Filters a queue.

  ## Examples

      iex> queue = Queue.from_list([1,2,3,4])
      iex> Queue.filter(queue, fn item -> rem(item, 2) != 0 end)
      #Queue<[1, 3]>

  """
  def filter(queue, func) do
    queue |> unwrap_store |> do_filter(func) |> wrap_store
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
  def to_list(queue) do
    queue |> unwrap_store |> :queue.to_list
  end

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
  def out(queue) do
    store = queue |> unwrap_store

    case :queue.out(store) do
      {{:value, item}, updated_store} ->
        {{:value, item}, wrap_store(updated_store)}
      {:empty, updated_store} ->
        {:empty, wrap_store(updated_store)}
    end
  end

  # TODO continue to add functions from the docs: https://erlang.org/doc/man/queue.html

  defp unwrap_store(%Queue{store: store}), do: store

  defp wrap_store(store), do: %Queue{store: store}

  defimpl Inspect do
    def inspect(queue, _) do
      "#Queue<#{inspect(:queue.to_list(queue.store))}>"
    end
  end
end
