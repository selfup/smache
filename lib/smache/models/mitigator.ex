defmodule Smache.Mitigator do
  alias Smache.Shard, as: Shard

  def fetch(key, data, ets_table) do
    dig(workers(), key, data, ets_table)
  end

  def grab_data(key) do
    dig(workers(), key)
  end

  defp workers() do
    ([Node.self()] ++ Node.list()) |> Enum.sort()
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

    {ukey, :cache_table}
  end

  defp dig(nodes, key) do
    {shard, delegator} = mitigate(nodes, key)

    case shard == Node.self() do
      true ->
        data(key)

      false ->
        node_data(delegator, [key])
    end
  end

  defp dig(nodes, key, data, ets_table) do
    {shard, delegator} = mitigate(nodes, key)

    case shard == Node.self() do
      true ->
        Smache.Ets.Table.fetch(key, data, ets_table)

      false ->
        node_fetch(delegator, [key, data, ets_table])
    end
  end

  defp mitigate(nodes, key) do
    ukey = Shard.is_num_or_str?(key)
    shard = rem(ukey, length(nodes))
    delegator = Enum.at(nodes, shard)

    {shard, delegator}
  end

  defp node_fetch(delegator, args) do
    :rpc.call(delegator, Smache.Ets.Table, :fetch, args)
  end

  defp node_data(delegator, args) do
    :rpc.call(delegator, Smache.Mitigator, :data, args)
  end
end
