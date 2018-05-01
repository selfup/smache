defmodule Smache.Mitigator do
  alias Smache.Shard, as: Shard

  @self Node.self()
  @ets_tables Shard.tables(:ets)

  def fetch(key, data, ets_table) do
    dig(workers(), key, data, ets_table)
  end
  
  def grab_data(key) do
    dig(workers(), key)
  end

  defp workers() do
    [@self] ++ Node.list
  end

  def data(key) do
    {_ukey, table} = ets_table(key)

    case :ets.lookup(table, key) do
      [] ->
        {@self, nil}

      [{_key, data}] ->
        {@self, data}
    end
  end

  def ets_table(key) do
    ukey = Shard.is_num_or_str?(key)
    shard = rem(ukey, length(@ets_tables))

    {ukey, Enum.at(@ets_tables, shard)}
  end

  defp dig(tracked_nodes, key) do
    {_shard, delegator} = mitigate(tracked_nodes, key)

    case delegator == @self do
      true ->
        data(key)

      false ->
        node_data(delegator, [key])
    end
  end

  defp dig(nodes, key, data, ets_table) do
    {_shard, delegator} = mitigate(nodes, key)

    case delegator == @self do
      true ->
        Smache.Ets.Table.fetch(key, data, ets_table)

      false ->
        node_fetch(delegator, [key, data, ets_table])
    end
  end

  defp mitigate(active_nodes, key) do
    ukey = Shard.is_num_or_str?(key)
    shard = rem(ukey, length(active_nodes))
    delegator = Enum.at(active_nodes, shard)

    {shard, delegator}
  end

  defp node_fetch(delegator, args) do
    :rpc.call(delegator, Smache.Ets.Table, :fetch, args)
  end

  defp node_data(delegator, args) do
    :rpc.call(delegator, Smache.Mitigator, :data, args)
  end
end
