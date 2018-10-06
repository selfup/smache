defmodule Smache.Mitigator do
  alias Smache.Normalizer, as: Normalizer

  def put_or_post(key, data) do
    dig(workers(), key, data)
  end

  def grab_data(key) do
    dig(workers(), key)
  end

  defp workers() do
    ([Node.self()] ++ Node.list()) |> Enum.sort()
  end

  def data(key) do
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
        data(key)

      false ->
        node_data(delegator, [key])
    end
  end

  defp dig(nodes, key, data) do
    delegator = mitigate(nodes, key)

    case delegator == Node.self() do
      true ->
        Smache.Ets.Table.put_or_post(key, data)

      false ->
        node_put_or_post(delegator, [key, data])
    end
  end

  defp mitigate(nodes, key) do
    ukey = Normalizer.normalize(key)

    index = rem(ukey, length(nodes))

    delegator = Enum.at(nodes, index)

    delegator
  end

  defp node_put_or_post(delegator, args) do
    :rpc.call(delegator, Smache.Ets.Table, :put_or_post, args)
  end

  defp node_data(delegator, args) do
    :rpc.call(delegator, Smache.Mitigator, :data, args)
  end
end
