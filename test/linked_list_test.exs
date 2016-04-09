defmodule LinkedListTest do
  use ExUnit.Case
  alias LinkedList.Node

  test ".new returns an empty linked list" do
    list = LinkedList.new

    assert is_pid(list)
    assert is_nil(LinkedList.head(list))
  end

  test ".new(%Node{}) return a linked list with the node as the head" do
    node = Node.new("head")
    list = LinkedList.new(node)

    assert is_pid(list)
    assert LinkedList.head(list) == node

  end

  test ".new(any) returns a linked list with Node.new(any) as the head" do
    list = LinkedList.new("head")

    assert is_pid(list)
    assert is_pid(LinkedList.head(list))
  end

  test ".new(list) returns a linked list populated with nodes from list" do
    list = LinkedList.new(["head", "body"])
    head = LinkedList.head(list)

    assert is_pid(list)
    assert is_pid(head)
    assert is_pid(Node.next(head))
  end

  test ".append add a node to the end of the list" do
    list = LinkedList.new
    head = Node.new("head")
    tail = Node.new("tail")

    LinkedList.append(list, head)
    LinkedList.append(list, tail)

    assert LinkedList.head(list) == head
    assert LinkedList.tail(list) == tail
  end

  test ".at finds the node at the given index" do
    list = LinkedList.new(["head", "tail"])

    assert is_pid(LinkedList.at(list, 0))
    assert is_pid(LinkedList.at(list, 1))
    assert is_nil(LinkedList.at(list, 2))

    LinkedList.append(list, "feet")
    assert is_pid(LinkedList.at(list, 2))
  end

  test ".len returns the length of the list" do
    list = LinkedList.new
    assert LinkedList.len(list) == 0

    LinkedList.append(list, "head")
    assert LinkedList.len(list) == 1

    LinkedList.append(list, "tail")
    assert LinkedList.len(list) == 2
  end

  test ".insert inserts at the provided index" do
    head = Node.new("head")
    tail = Node.new("tail")
    list = LinkedList.new
    LinkedList.append(list, head)
    LinkedList.append(list, tail)

    node = Node.new("body")

    LinkedList.insert(list, node, 1)
    assert LinkedList.at(list, 1) == node
    assert Node.next(head) == node
    assert Node.next(node) == tail
  end

  test ".insert(0) inserts as the new head" do
    head = Node.new("head")
    tail = Node.new("tail")
    list = LinkedList.new
    LinkedList.append(list, head)
    LinkedList.append(list, tail)

    new_head = Node.new("hat")
    LinkedList.insert(list, new_head, 0)
    assert Node.next(new_head) == head
  end

  test ".insert(len) appends to the end of the list" do
    head = Node.new("head")
    tail = Node.new("tail")
    list = LinkedList.new
    LinkedList.append(list, head)
    LinkedList.append(list, tail)

    feet = Node.new("feet")

    LinkedList.insert(list, feet, 2)
    assert LinkedList.tail(list) == feet
  end
end
