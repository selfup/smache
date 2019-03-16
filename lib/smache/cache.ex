defmodule Smache.Cache do
  def put_or_post(id, data) do
    find_and_create_or_update(id, data)
  end

  defp find_and_create_or_update(id, data) do
    case get(id) do
      {:not_found} ->
        set(id, data)

      {:found, found_data} ->
        get_or_update(id, data, found_data)
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

  defp get_or_update(id, data, found_data) do
    case Map.equal?(data, found_data) do
      true ->
        %{data: data}

      false ->
        set(id, data)
    end
  end
end
