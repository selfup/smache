defmodule Smache.Cache.Model do
  def fetch(id, data, ets_table) do
    existing_data?(id, data, ets_table)
  end

  defp existing_data?(id, data, ets_table) do
    case get(id, ets_table) do
      {:not_found} ->
        %{data: set(id, data, ets_table)}

      {:found, id_data} ->
        %{data: already_in(id, data, id_data, ets_table)}
    end
  end

  def get(id, ets_table) do
    case :ets.lookup(ets_table, id) do
      [] ->
        {:not_found}

      [{_id, data}] ->
        {:found, data}
    end
  end

  # when another node needs to sync its data
  def sync_data(payload, ets_table) do
    true = :ets.insert(ets_table, payload)
  end

  defp set(id, data, ets_table) do
    true = :ets.insert(ets_table, {id, data})
    data
  end

  def remove_data(id) do
    true = :ets.delete(id)
  end

  defp already_in(id, data, id_data, ets_table) do
    case Map.equal?(data, id_data) do
      true ->
        data

      false ->
        set(id, data, ets_table)
    end
  end
end
