defmodule QueueTest do
  use ExUnit.Case, async: true
  doctest Queue

  describe "new/0" do
    test "returns an empty queue" do
      assert Queue.new() == %Queue{store: :queue.new()}
    end
  end

  describe "from_list/1" do
    test "returns a queue from a list" do
      list = [1,2,3]
      queue = Queue.from_list(list)
      assert Queue.to_list(queue) == list
    end
  end

  describe "to_list/1" do
    test "returns a list of items in the queue" do
      list = [1, 2, 3, 4]
      queue = Queue.from_list list
      assert Queue.to_list(queue) == list
    end
  end

  describe "in_l/2" do
    test "enqueues an item at end of queue" do
      queue = Queue.from_list [1, 2]
      queue = Queue.in_l(queue, 3)
      assert Queue.to_list(queue) == [1, 2, 3]
    end
  end

  describe "in_r/2" do
    test "enqueues an item at the front of the queue" do
      queue = Queue.from_list [1, 2]
      queue = Queue.in_r(queue, 3)
      assert Queue.to_list(queue) == [3, 1, 2]
    end
  end

  describe "empty?/1" do
    test "returns true when queue is empty" do
      queue = Queue.new
      assert Queue.empty?(queue) == true
    end

    test "returns false when queue is not empty" do
      queue = Queue.from_list [1]
      assert Queue.empty?(queue) == false
    end
  end

  describe "queue?/1" do
    test "returns true when is a queue" do
      queue = Queue.new
      assert Queue.queue?(queue) == true
    end

    test "returns false when is not queue" do
      assert Queue.queue?(%{}) == false
      assert Queue.queue?(4) == false
      assert Queue.queue?("test") == false
    end

    test "returns false when underlying implementation is not a queue" do
      queue = %Queue{store: []}
      assert Queue.queue?(queue) == false
    end
  end

  describe "join/2" do
    test "joins two queues with the first given in front" do
      queue1 = Queue.from_list([1, 2])
      queue2 = Queue.from_list([3, 4])
      queue3 = Queue.join(queue1, queue2)
      assert Queue.to_list(queue3) == [1, 2, 3, 4]
    end
  end

  describe "out/1" do
    test "removes item from the queue" do
      queue = Queue.from_list [1, 2]
      assert {{:value, 1}, %Queue{} = queue} = Queue.out(queue)
      assert {{:value, 2}, %Queue{} = queue} = Queue.out(queue)
      assert {:empty, queue} = Queue.out(queue)
    end
  end

  describe "filter/2" do
    test "filters items in a queue" do
      queue = Queue.from_list [1, 2, 3, 4]
      even_only = fn item -> rem(item, 2) == 0 end
      queue = Queue.filter(queue, even_only)
      assert queue == Queue.from_list [2, 4]
    end
  end
end
