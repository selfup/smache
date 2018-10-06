defmodule Smache.Mitigator do
  @moduledoc"""
  The Smache.Mitigator module is essentially the brain of the distributed nature of smache
  It figures out where the data lives and then grabs or updates the data
  """

  alias Smache.Normalizer, as: Normalizer

  def put_or_post(key, data) do
    dig(workers(), key, data)
  end

  def get_data(key) do
    dig(workers(), key)
  end

  defp workers() do
    ([Node.self()] ++ Node.list()) |> Enum.sort()
  end

  def get(key) do
    case :ets.lookup(:smache_cache, key) do
      [] ->
        {Node.self(), nil}

      [{_key, data}] ->
        {Node.self(), data}
    end
  end

  defp dig(nodes, key) do
    delegator = mitigate(nodes, key)

    case delegator == Node.self() do
      true ->
        get(key)

      false ->
        distributed_get(delegator, [key])
    end
  end

  defp dig(nodes, key, data) do
    delegator = mitigate(nodes, key)

    case delegator == Node.self() do
      true ->
        Smache.Ets.Table.put_or_post(key, data)

      false ->
        distributed_put_or_post(delegator, [key, data])
    end
  end

  defp mitigate(nodes, key) do
    ukey = Normalizer.normalize(key)

    index = rem(ukey, length(nodes))

    delegator = Enum.at(nodes, index)

    delegator
  end

  defp distributed_put_or_post(delegator, args) do
    :rpc.call(delegator, Smache.Ets.Table, :put_or_post, args)
  end

  defp distributed_get(delegator, args) do
    :rpc.call(delegator, Smache.Mitigator, :get, args)
  end
end
