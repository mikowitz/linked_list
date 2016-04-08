defmodule LinkedList.Node do
  alias __MODULE__

  @type t :: pid
  @type node_struct :: %Node{ data: any, next: pid | none }
  defstruct data: nil, next: nil

  @doc """
  Creates a new node storing `data`

      iex> node = Node.new("head")
      #PID<0.22.0>

  """
  @spec new(any) :: Node.t
  def new(data) do
    {:ok, pid} = Agent.start_link(fn ->
      %Node{ data: data }
    end)
    pid
  end

  @doc """
  Returns `node`'s next node, if it exists

      iex> node = Node.new("head")
      iex> Node.next(node)
      nil
      iex> Node.next(node, Node.new("tail")
      iex> Node.next(node)
      #PID<0.23.0>

  """
  @spec next(Node.t) :: Node.t
  def next(node) do
    Agent.get(node, fn struct -> struct end).next
  end

  @doc """
  Sets `node.next` to `next_node`

      iex> node = Node.new("head")
      iex> tail_node = Node.new("tail")
      iex> Node.next(node, tail_node)
      iex> Node.next(node) == tail_node
      true

  """
  @spec next(Node.t, Node.t) :: Node.t
  def next(node, next_node) when is_pid(next_node) do
    Agent.update(node, fn struct ->
      %Node{ struct | next: next_node }
    end)
  end

  @spec next(Node.t, any) :: Node.t
  def next(node, next_data) do
    next(node, new(next_data))
  end

  @doc """
  Returns the data stored in the node

      iex> node = Node.new("head")
      iex> Node.data(node)
      "head"

  """
  @spec data(Node.t) :: any
  def data(node) do
    Agent.get(node, fn %{data: data} -> data end)
  end
end
