defmodule Downlink.Operator do
  def sync(nodes) do
    connect_to_workers(nodes)
  end

  defp connect_to_workers(nodes) do
    Enum.each(nodes, &Node.ping(&1))
  end
end
