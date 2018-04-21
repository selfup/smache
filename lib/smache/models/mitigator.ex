defmodule Smache.Mitigator do
  alias Smache.Cache.Shard.Model, as: Shard

  @ets_tables Shard.tables(:ets)

  def fetch(key, data, ets_table) do
    case :ets.lookup(:nodes, :active_nodes) do
      [] ->
        Smache.Ets.Table.fetch(key, data, ets_table)

      [{_, tracked_nodes}] ->
        dig(tracked_nodes, key, data, ets_table)
    end
  end

  def grab_data(key) do
    [{_, tracked_nodes}] = :ets.lookup(:nodes, :active_nodes)

    case tracked_nodes do
      [] ->
        data(key)

      nodes ->
        shallow_dig(nodes, key)
    end
  end

  def data(key) do
    {_ukey, table} = ets_table(key)

    case :ets.lookup(table, key) do
      [] ->
        {Node.self(), nil}

      [{_key, data}] ->
        {Node.self(), data}
    end
  end

  def ets_table(key) do
    ukey = Shard.is_num_or_str?(key)
    shard = rem(ukey, length(@ets_tables))

    {ukey, Enum.at(@ets_tables, shard)}
  end

  defp shallow_dig(tracked_nodes, key) do
    active_nodes = active_nodes(tracked_nodes)
    {_shard, delegator} = mitigate(active_nodes, key)

    case delegator == Node.self() do
      true ->
        data(key)

      false ->
        node_data(delegator, [key])
    end
  end

  defp dig(tracked_nodes, key, data, ets_table) do
    case active_nodes(tracked_nodes) do
      [] ->
        Smache.Ets.Table.fetch(key, data, ets_table)

      nodes ->
        {_shard, delegator} = mitigate(nodes, key)

        case delegator == Node.self() do
          true ->
            Smache.Ets.Table.fetch(key, data, ets_table)

          false ->
            node_fetch(delegator, [key, data, ets_table])
        end
    end
  end

  defp mitigate(active_nodes, key) do
    ukey = Shard.is_num_or_str?(key)
    shard = rem(ukey, length(active_nodes))
    delegator = Enum.at(active_nodes, shard)

    {shard, delegator}
  end

  defp active_nodes(nodes) do
    nodes |> Enum.map(fn {node, _status} -> node end)
  end

  defp node_fetch(delegator, args) do
    Task.Supervisor.async(
      {Smache.Task.Supervisor, delegator},
      Smache.Ets.Table,
      :fetch,
      args
    )
    |> Task.await()
  end

  defp node_data(delegator, args) do
    Task.Supervisor.async(
      {Smache.Task.Supervisor, delegator},
      Smache.Mitigator,
      :data,
      args
    )
    |> Task.await()
  end
end
