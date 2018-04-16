defmodule Smache.Supervisor do
  alias Smache.Ets.Table, as: EtsTable
  alias Smache.Cache.Shard.Model, as: Shard
  alias Smache.DiscoverNodes, as: DiscoverNodes

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    ets_table_names = Shard.tables(:ets)

    children =
      ets_table_names
      |> Enum.map(fn name ->
        worker(EtsTable, [[name: name]], id: name)
      end)

    all_children = [worker(DiscoverNodes, [])] ++ children

    supervise(all_children, strategy: :one_for_one)
  end
end
