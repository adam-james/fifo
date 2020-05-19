defmodule QueueTest do
  use ExUnit.Case, async: true
  doctest Queue

  describe "new/0" do
    test "returns an empty queue" do
      assert Queue.new() == %Queue{store: :queue.new()}
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

  describe "filter/2" do
    test "filters items in a queue" do
      queue = Queue.from_list [1, 2, 3, 4]
      even_only = fn item -> rem(item, 2) == 0 end
      queue = Queue.filter(queue, even_only)
      assert queue == Queue.from_list [2, 4]
    end
  end
end
