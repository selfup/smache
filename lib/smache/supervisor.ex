defmodule Smache.Supervisor do
  alias Smache.Ets.Table, as: EtsTable
  alias Smache.Shard, as: Shard
  alias Downlink.Server, as: Downlink
  alias Uplink.Server, as: Uplink

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    all_children =
      [
        worker(EtsTable, [[name: :cache_table]], id: :cache_table),
        worker(Uplink, [UplinkServer]),
        worker(Downlink, [DownlinkServer])
      ]

    supervise(all_children, strategy: :one_for_one)
  end
end
