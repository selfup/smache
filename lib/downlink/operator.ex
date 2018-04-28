defmodule Downlink.Operator do
  def sync(active_nodes) do
    IO.puts "DOWNLINK OPERATOR SYNC ACTIVE NODES"
    IO.inspect active_nodes
    true = :ets.insert(:downlink, {:active_nodes, active_nodes})
  end
end
