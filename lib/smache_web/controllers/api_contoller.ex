defmodule SmacheWeb.ApiController do
  alias Smache.Cache.Shard.Model, as: Shard
  alias Smache.Cmd.Model, as: Cmd

  use SmacheWeb, :controller

  @ets_tables Shard.tables(:ets)

  def show(conn, %{"key" => key} = _params) do
    case key_is_nil?(conn, key) do
      :proceed_with_request ->
        valid_key = Shard.is_num_or_str?(key)

        valid_data = valid_key |> data()

        json(conn, %{
          key: valid_key,
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

  def cmd(conn, %{"key" => key, "cmd" => cmd} = _params) do
    case key_is_nil?(conn, key) do
      :proceed_with_request ->
        %{"query" => query, "keys" => keys} = cmd

        case Cmd.exe(query, keys, data(key)) do
          :error ->
            conn
            |> put_status(403)
            |> json(%{message: "#{query} not supported"})

          data ->
            json(conn, data)
        end
      
      forbidden_key_type_response ->
        forbidden_key_type_response
    end
  end

  defp fetch(key, data, ets_table) do
    Smache.Ets.Table.fetch(key, data, ets_table)
  end

  defp data(key) do
    {_ukey, table} = ets_table(key)

    case :ets.lookup(table, key) do
      [] ->
        nil

      [{_key, data}] ->
        data
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
