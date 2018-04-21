defmodule Yo.Delegator do
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
    grab_active_node_names()
    |> Enum.map(&Task.async(fn -> Node.ping(&1) end))
    |> Enum.map(&(Task.await(&1) == :ping))
    |> Enum.zip(grab_active_node_names())
    |> Enum.filter(fn {up, _name} -> up == true end)
    |> Enum.map(fn {_up, name} -> name end)
    |> update_all_node_names

    grab_active_node_names
    |> IO.inspect
  end

  defp update?(names, name) do
    case Enum.any?(names, &(&1 == name)) do
      true ->
        grab_active_node_names()

      false ->
        synced = names ++ [name]
        true = :ets.insert(:node_names, {:synced, synced})
        grab_active_node_names()
    end
  end

  defp update_all_node_names(names) do
    true = :ets.insert(:node_names, {:synced, names})
  end

  defp grab_active_node_names() do
    [{_, active_node_names}] = lookup_synced()
    active_node_names
  end

  defp lookup_synced() do
    :ets.lookup(:node_names, :synced)
  end
end
