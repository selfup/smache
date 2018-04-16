defmodule SmacheWeb.ApiController do
  alias Smache.Cache.Shard.Model, as: Shard

  use SmacheWeb, :controller

  @ets_tables Shard.tables(:ets)

  def show(conn, %{"key" => key} = _params) do
    case key_is_nil?(conn, key) do
      :proceed_with_request ->
        valid_key = Shard.is_num_or_str?(key)

        {node, valid_data} =
          valid_key
          |> data_from_self_or_other_node()

        json(conn, %{
          key: valid_key,
          node: node,
          data: valid_data
        })

      forbidden_key_type_response ->
        forbidden_key_type_response
    end
  end

  def create_or_update(conn, %{"key" => key, "data" => data} = _params) do
    case key_is_nil?(conn, key) do
      :proceed_with_request ->
        {ukey, table} = ets_table(key)

        json(conn, fetch(ukey, data, table))

      forbidden_key_type_response ->
        forbidden_key_type_response
    end
  end

  defp fetch(key, data, ets_table) do
    case :ets.lookup(:nodes, :active_nodes) do
      _ ->
        Smache.Ets.Table.fetch(key, data, ets_table)

      [{_, active_nodes_info}] ->
        active_nodes =
          active_nodes_info
          |> Enum.map(fn {node, _status} -> node end)

        ukey = Shard.is_num_or_str?(key)

        case active_nodes do
          [] ->
            Smache.Ets.Table.fetch(key, data, ets_table)

          nodes ->
            shard = rem(ukey, length(nodes))

            delegator = Enum.at(active_nodes, shard)

            case delegator == Node.self() do
              true ->
                Smache.Ets.Table.fetch(key, data, ets_table)

              false ->
                :rpc.call(delegator, Smache.Ets.Table, :fetch, [key, data, ets_table])
            end
        end
    end
  end

  def data_from_self_or_other_node(key) do
    case :ets.lookup(:nodes, :active_nodes) do
      _ ->
        data(key)

      [{_, active_nodes_info}] ->
        active_nodes =
          active_nodes_info
          |> Enum.map(fn {node, _status} -> node end)

        ukey = Shard.is_num_or_str?(key)
        shard = rem(ukey, length(active_nodes))

        delegator = Enum.at(active_nodes, shard)

        case delegator == Node.self() do
          true ->
            data(key)

          false ->
            :rpc.call(delegator, SmacheWeb.ApiController, :data, [key])
        end
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

  defp ets_table(key) do
    ukey = Shard.is_num_or_str?(key)

    shard = rem(ukey, length(@ets_tables))

    {ukey, Enum.at(@ets_tables, shard)}
  end

  defp key_is_nil?(conn, key) do
    if is_nil(key) do
      conn
      |> put_status(403)
      |> json(%{message: "key cannot be null"})
    else
      :proceed_with_request
    end
  end
end
