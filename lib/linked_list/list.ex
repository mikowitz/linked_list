defmodule LinkedList.List do
  defmacro __using__(_) do
    quote do
      alias LinkedList.Node
      alias __MODULE__

      @type t :: pid
      @type linked_list_struct :: %__MODULE__{ head: Node.t }
      @type maybe_node :: Node.t | none
      defstruct head: nil

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
          %__MODULE__{ list | head: node }
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
        case Agent.get(ll, &(&1)) do
          %{ head: nil } -> nil
          %{ head: head } ->
            find_tail(head)
        end
      end

      @spec append(__MODULE__.t, Node.t) :: __MODULE__.t
      def append(ll, n) when is_pid(n) do
        case Agent.get(ll, &(&1)) do
          %{head: nil } ->
            Agent.update(ll, fn list ->
              %__MODULE__{ list | head: n }
            end)
          _ ->
            Node.next(tail(ll), n)
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
