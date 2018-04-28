defmodule Uplink.Operator do
  def sync() do
    nodes = Node.list()

    nodes
    |> Enum.map(&Task.async(downlink_sync(&1, nodes)))
    |> Enum.map(&Task.await(&1))
  end

  defp downlink_sync(node, nodes) do
    fn ->
      :rpc.call(node, Downlink.Operator, :sync, [nodes])
    end
  end
end
