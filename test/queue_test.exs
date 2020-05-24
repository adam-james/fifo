defmodule QueueTest do
  use ExUnit.Case, async: true
  doctest Queue

  test "new/0" do
    assert Queue.new() == %Queue{store: :queue.new()}
  end

  test "new/1" do
    queue = Queue.new(1..5)
    assert Queue.to_list(queue) == Enum.into(1..5, [])

    queue = Queue.new([1, 2, 3, 4, 5])
    assert Queue.to_list(queue) == Enum.into(1..5, [])
  end

  test "new/2" do
    squared = fn n -> n * n end
    queue = Queue.new(1..3, squared)
    assert Queue.to_list(queue) == [1, 4, 9]

    queue = Queue.new([1, 2, 3], squared)
    assert Queue.to_list(queue) == [1, 4, 9]
  end

  test "from_list/1" do
    list = [1, 2, 3]
    queue = Queue.from_list(list)
    assert Queue.to_list(queue) == list
  end

  test "filter/2" do
    queue = Queue.from_list([1, 2, 3, 4])
    even_only = fn item -> rem(item, 2) == 0 end
    queue = Queue.filter(queue, even_only)
    assert queue == Queue.from_list([2, 4])
  end

  test "to_list/1" do
    list = [1, 2, 3, 4]
    queue = Queue.from_list(list)
    assert Queue.to_list(queue) == list
  end

  test "push/2" do
    queue = Queue.from_list([1, 2])
    queue = Queue.push(queue, 3)
    assert Queue.to_list(queue) == [1, 2, 3]
  end

  test "push_r/2" do
    queue = Queue.from_list([1, 2])
    queue = Queue.push_r(queue, 3)
    assert Queue.to_list(queue) == [3, 1, 2]
  end

  test "empty?/1" do
    queue = Queue.new()
    assert Queue.empty?(queue) == true

    queue = Queue.from_list([1])
    assert Queue.empty?(queue) == false
  end

  test "queue?/1" do
    queue = Queue.new()
    assert Queue.queue?(queue) == true

    assert Queue.queue?(%{}) == false
    assert Queue.queue?(4) == false
    assert Queue.queue?("test") == false

    queue = %Queue{store: []}
    assert Queue.queue?(queue) == false
  end

  test "join/2" do
    queue1 = Queue.from_list([1, 2])
    queue2 = Queue.from_list([3, 4])
    queue3 = Queue.join(queue1, queue2)
    assert Queue.to_list(queue3) == [1, 2, 3, 4]
  end

  test "size/1" do
    assert Queue.size(Queue.new()) == 0
    assert Queue.size(Queue.new([1])) == 1
    assert Queue.size(Queue.new(1..100)) == 100
  end

  test "member?/2" do
    queue = Queue.new(1..5)
    assert Queue.member?(queue, 1) == true
    assert Queue.member?(queue, 5) == true
    assert Queue.member?(queue, 100) == false
  end

  test "pop/1" do
    queue = Queue.new([1, 2])
    assert {{:value, 1}, %Queue{} = queue} = Queue.pop(queue)
    assert {{:value, 2}, %Queue{} = queue} = Queue.pop(queue)
    assert {:empty, queue} = Queue.pop(queue)
  end

  test "pop_r/1" do
    queue = Queue.new([1, 2])
    assert {{:value, 2}, %Queue{} = queue} = Queue.pop_r(queue)
    assert {{:value, 1}, %Queue{} = queue} = Queue.pop_r(queue)
    assert {:empty, queue} = Queue.pop_r(queue)
  end

  test "reverse/1" do
    queue = Queue.new([1, 2, 3])
    reversed = Queue.reverse(queue)
    assert Queue.to_list(reversed) == [3, 2, 1]
  end

  test "split/2" do
    queue = Queue.from_list([1, 2, 3])
    {queue2, queue3} = Queue.split(queue, 1)

    assert Queue.to_list(queue2) == [1]
    assert Queue.to_list(queue3) == [2, 3]
  end
end

defmodule QueueTest.EnumerableTest do
  use ExUnit.Case, async: true

  test "implements count/1" do
    queue = Queue.new()
    assert Enum.count(queue) == 0
    queue = Queue.new(1..100)
    assert Enum.count(queue) == 100
  end

  test "implements member?/2" do
    queue = Queue.new()
    refute Queue.member?(queue, 3)
    queue = Queue.new(1..100)
    assert Queue.member?(queue, 1)
    assert Queue.member?(queue, 10)
    assert Queue.member?(queue, 100)
  end

  # TODO arity?
  test "implements slice" do
    queue = Queue.new(1..10)
    assert Enum.slice(queue, 1..3) == [2, 3, 4]
  end

  # TODO arity?
  test "implements reduce" do
    queue = Queue.new([1, 2, 3])
    squared = fn n -> n * n end
    assert Enum.map(queue, squared) == [1, 4, 9]
  end
end

defmodule QueueTest.CollectableTest do
  use ExUnit.Case, async: true

  test "implements Collectable protocol" do
    list = [1, 2, 3]
    queue = Enum.into(list, Queue.new())
    assert queue == Queue.new(list)
  end
end
