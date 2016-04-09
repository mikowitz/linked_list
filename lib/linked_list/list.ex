defmodule LinkedList.List do
  defmacro __using__(_) do
    quote do
      alias LinkedList.Node
      alias __MODULE__

      @type t :: pid
      @type maybe_node :: Node.t | none
      @type linked_list_struct :: %__MODULE__{ head: maybe_node, tail: maybe_node }
      defstruct head: nil, tail: nil

      @spec new :: __MODULE__.t
      def new do
        {:ok, pid} = Agent.start_link(fn ->
          %__MODULE__{}
        end)
        pid
      end

      @spec new(Node.t) :: __MODULE__.t
      def new(node) when is_pid(node) do
        ll = new
        Agent.update(ll, fn list ->
          %__MODULE__{ list | head: node, tail: node }
        end)
        ll
      end

      @spec new(list(any)) :: __MODULE__.t
      def new(list) when is_list(list) do
        [h|t] = list
        ll = new(h)
        append_list(ll, t)
      end

      @spec new(any) :: __MODULE__.t
      def new(head) do
        node = Node.new(head)
        new(node)
      end

      @spec head(__MODULE__.t) :: maybe_node
      def head(ll) do
        Agent.get(ll, fn %{head: head} -> head end)
      end

      @spec tail(__MODULE__.t) :: maybe_node
      def tail(ll) do
        Agent.get(ll, fn %{tail: tail} -> tail end)
      end

      @spec append(__MODULE__.t, Node.t) :: __MODULE__.t
      def append(ll, n) when is_pid(n) do
        case Agent.get(ll, &(&1)) do
          %{head: nil } ->
            Agent.update(ll, fn list ->
              %__MODULE__{ list | head: n, tail: n }
            end)
          _ ->
            Node.next(tail(ll), n)
            Agent.update(ll, fn list ->
              %__MODULE__{ list | tail: n }
            end)
        end
        ll
      end

      @spec append(__MODULE__.t, any) :: __MODULE__.t
      def append(ll, h) do
        append(ll, Node.new(h))
      end

      @spec at(__MODULE__.t, integer) :: maybe_node
      def at(ll, 0), do: head(ll)
      def at(ll, i) do
        find_at(head(ll), i)
      end

      @spec len(__MODULE__.t) :: integer
      def len(ll) do
        case head(ll) do
          nil -> 0
          node -> find_len(node, 1)
        end
      end

      defp find_len(node, i) do
        case Node.next(node) do
          nil -> i
          next_node -> find_len(next_node, i + 1)
        end
      end

      @spec insert(__MODULE__.t, Node.t, integer) :: __MODULE__.t
      def insert(ll, n, 0) when is_pid(n) do
        Node.next(n, head(ll))
        Agent.update(ll, fn list ->
          %__MODULE__{ list | head: n }
        end)
      end
      def insert(ll, n, i) when is_pid(n) do
        cond do
          i == len(ll) ->
            append(ll, n)
          i < len(ll) ->
            before_node = at(ll, i-1)
            after_node = at(ll, i)

            Node.next(n, after_node)
            Node.next(before_node, n)
          true -> nil
        end
        ll
      end

      @spec insert(__MODULE__.t, any, integer) :: __MODULE__.t
      def insert(ll, h, i) do
        insert(ll, Node.new(h), i)
      end

      defp find_at(nil, i), do: nil
      defp find_at(node, 0), do: node
      defp find_at(node, i) do
        find_at(Node.next(node), i-1)
      end

      defp append_list(ll, []), do: ll
      defp append_list(ll, [h|t]) do
        append(ll, h) |> append_list(t)
      end

      defp find_tail(node) do
        case Agent.get(node, &(&1)) do
          %{ next: nil } -> node
          %{ next: next} -> find_tail(next)
        end
      end
    end
  end
end
