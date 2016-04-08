defmodule LinkedList.NodeTest do
  use ExUnit.Case
  alias LinkedList.Node

  test ".new returns a PID to a new node" do
    assert is_pid(Node.new("head"))
  end

  test ".next/1 returns nil if there is no next node" do
    node = Node.new("head")

    assert Node.next(node) == nil
  end

  test ".next/2 attaches a node and next/1 returns the PID of the next node" do
    node = Node.new("head")
    next = Node.new("tail")
    Node.next(node, next)

    assert Node.next(node) == next
  end

  test ".next/2 can also take raw data" do
    node = Node.new("head")
    Node.next(node, "tail")
    assert is_pid(Node.next(node))
  end

  test ".data returns the raw data stored in the node" do
    node = Node.new("head")
    assert Node.data(node) == "head"
  end
end
