defmodule Uplink.Operator do
  alias Downlink.Server, as: Downlink

  def post(name) when is_atom(name) do
    case lookup_synced() do
      [] ->
        {:ok, update?([], name)}

      [{_, names}] ->
        {:ok, update?(names, name)}
    end
  end

  def post(_name) do
    {:error, :not_an_atom}
  end

  def sync() do
    active_nodes()
    |> Enum.map(&Task.async(fn -> Node.ping(&1) end))
    |> Enum.map(&(Task.await(&1) == :pong))
    |> Enum.zip(active_nodes())
    |> Enum.filter(fn {up, _name} -> up == true end)
    |> Enum.map(fn {_up, name} -> name end)
    |> update_all_nodes
  end

  defp update?(names, name) do
    case Enum.any?(names, &(&1 == name)) do
      true ->
        names

      false ->
        synced = names ++ [name]
        true = :ets.insert(:uplink, {:synced, synced})
        synced
    end
  end

  defp update_all_nodes(nodes) do
    if nodes != active_nodes() do
      nodes
      |> Enum.map(&Task.async(downlink_sync(&1, nodes)))
      |> Enum.map(&Task.await(&1))

      true = :ets.insert(:uplink, {:synced, nodes})
    end
  end

  defp downlink_sync(node, nodes) do
    fn -> IO.inpsect :rpc.call(node, Downlink, :sync, [nodes]) end
  end

  defp active_nodes() do
    [{_, names}] = lookup_synced()
    names
  end

  defp lookup_synced() do
    :ets.lookup(:uplink, :synced)
  end
end
