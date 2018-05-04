defmodule Smache.Cache do
  def fetch(id, data) do
    existing_data?(id, data)
  end

  defp existing_data?(id, data) do
    case get(id) do
      {:not_found} ->
        set(id, data)

      {:found, id_data} ->
        already_in(id, data, id_data)
    end
  end

  def get(id) do
    case :ets.lookup(:smache_cache, id) do
      [] ->
        {:not_found}

      [{_id, data}] ->
        {:found, data}
    end
  end

  defp set(id, data) do
    true = :ets.insert(:smache_cache, {id, data})
    %{data: data}
  end

  def remove_data(id) do
    true = :ets.delete(id)
  end

  defp already_in(id, data, id_data) do
    case Map.equal?(data, id_data) do
      true ->
        %{data: data}

      false ->
        set(id, data)
    end
  end
end
