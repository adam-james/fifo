defmodule FIFOTest do
  use ExUnit.Case, async: true
  doctest FIFO

  test "new/0" do
    assert FIFO.new() == %FIFO{store: :queue.new()}
  end

  test "new/1" do
    queue = FIFO.new(1..5)
    assert FIFO.to_list(queue) == Enum.into(1..5, [])

    queue = FIFO.new([1, 2, 3, 4, 5])
    assert FIFO.to_list(queue) == Enum.into(1..5, [])
  end

  test "new/2" do
    squared = fn n -> n * n end
    queue = FIFO.new(1..3, squared)
    assert FIFO.to_list(queue) == [1, 4, 9]

    queue = FIFO.new([1, 2, 3], squared)
    assert FIFO.to_list(queue) == [1, 4, 9]
  end

  test "from_list/1" do
    list = [1, 2, 3]
    queue = FIFO.from_list(list)
    assert FIFO.to_list(queue) == list
  end

  test "equal?/2" do
    queue1 = FIFO.new([1, 2, 3])
    queue2 = FIFO.new() |> FIFO.push(1) |> FIFO.push(2) |> FIFO.push(3)
    assert FIFO.equal?(queue1, queue2)

    queue3 = FIFO.reverse(queue2)
    refute FIFO.equal?(queue1, queue3)

    queue4 = FIFO.new([3, 4, 5])
    refute FIFO.equal?(queue1, queue4)
  end

  test "filter/2" do
    queue = FIFO.from_list([1, 2, 3, 4])
    even_only = fn item -> rem(item, 2) == 0 end
    queue = FIFO.filter(queue, even_only)
    assert queue == FIFO.from_list([2, 4])
  end

  test "to_list/1" do
    list = [1, 2, 3, 4]
    queue = FIFO.from_list(list)
    assert FIFO.to_list(queue) == list
  end

  test "push/2" do
    queue = FIFO.from_list([1, 2])
    queue = FIFO.push(queue, 3)
    assert FIFO.to_list(queue) == [1, 2, 3]
  end

  test "push_r/2" do
    queue = FIFO.from_list([1, 2])
    queue = FIFO.push_r(queue, 3)
    assert FIFO.to_list(queue) == [3, 1, 2]
  end

  test "empty?/1" do
    queue = FIFO.new()
    assert FIFO.empty?(queue) == true

    queue = FIFO.from_list([1])
    assert FIFO.empty?(queue) == false
  end

  test "queue?/1" do
    queue = FIFO.new()
    assert FIFO.queue?(queue) == true

    assert FIFO.queue?(%{}) == false
    assert FIFO.queue?(4) == false
    assert FIFO.queue?("test") == false

    queue = %FIFO{store: []}
    assert FIFO.queue?(queue) == false
  end

  test "join/2" do
    queue1 = FIFO.from_list([1, 2])
    queue2 = FIFO.from_list([3, 4])
    queue3 = FIFO.join(queue1, queue2)
    assert FIFO.to_list(queue3) == [1, 2, 3, 4]
  end

  test "length/1" do
    assert FIFO.length(FIFO.new()) == 0
    assert FIFO.length(FIFO.new([1])) == 1
    assert FIFO.length(FIFO.new(1..100)) == 100
  end

  test "member?/2" do
    queue = FIFO.new(1..5)
    assert FIFO.member?(queue, 1) == true
    assert FIFO.member?(queue, 5) == true
    assert FIFO.member?(queue, 100) == false
  end

  test "pop/1" do
    queue = FIFO.new([1, 2])
    assert {{:value, 1}, %FIFO{} = queue} = FIFO.pop(queue)
    assert {{:value, 2}, %FIFO{} = queue} = FIFO.pop(queue)
    assert {:empty, queue} = FIFO.pop(queue)
  end

  test "pop_r/1" do
    queue = FIFO.new([1, 2])
    assert {{:value, 2}, %FIFO{} = queue} = FIFO.pop_r(queue)
    assert {{:value, 1}, %FIFO{} = queue} = FIFO.pop_r(queue)
    assert {:empty, queue} = FIFO.pop_r(queue)
  end

  test "reverse/1" do
    queue = FIFO.new([1, 2, 3])
    reversed = FIFO.reverse(queue)
    assert FIFO.to_list(reversed) == [3, 2, 1]
  end

  test "split/2" do
    queue = FIFO.from_list([1, 2, 3])
    {queue2, queue3} = FIFO.split(queue, 1)

    assert FIFO.to_list(queue2) == [1]
    assert FIFO.to_list(queue3) == [2, 3]
  end
end

defmodule FIFOTest.EnumerableTest do
  use ExUnit.Case, async: true

  test "implements count/1" do
    queue = FIFO.new()
    assert Enum.count(queue) == 0
    queue = FIFO.new(1..100)
    assert Enum.count(queue) == 100
  end

  test "implements member?/2" do
    queue = FIFO.new()
    refute FIFO.member?(queue, 3)
    queue = FIFO.new(1..100)
    assert FIFO.member?(queue, 1)
    assert FIFO.member?(queue, 10)
    assert FIFO.member?(queue, 100)
  end

  # TODO arity?
  test "implements slice" do
    queue = FIFO.new(1..10)
    assert Enum.slice(queue, 1..3) == [2, 3, 4]
  end

  # TODO arity?
  test "implements reduce" do
    queue = FIFO.new([1, 2, 3])
    squared = fn n -> n * n end
    assert Enum.map(queue, squared) == [1, 4, 9]
  end
end

defmodule FIFOTest.CollectableTest do
  use ExUnit.Case, async: true

  test "implements Collectable protocol" do
    list = [1, 2, 3]
    queue = Enum.into(list, FIFO.new())
    assert queue == FIFO.new(list)
  end
end
