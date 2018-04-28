defmodule Downlink.Operator do
  def sync(active_nodes) do
    true = :ets.insert(:downlink, {:active_nodes, active_nodes})
  end
end
