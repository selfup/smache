defmodule Downlink.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    :ets.new(:nodes, [
      :named_table,
      :set,
      :public,
      read_concurrency: true
    ])

    register()

    {:ok, state}
  end

  def sync(active_nodes) do
    true = :ets.insert(:nodes, {:active_nodes, active_nodes})
  end

  defp register do
    mitigator = System.get_env("MITIGATOR") || nil

    :rpc.call(:"#{mitigator}", Uplink.Sync, :post, [Node.self()])
  end
end
