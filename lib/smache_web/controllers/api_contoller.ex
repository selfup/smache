defmodule SmacheWeb.ApiController do
  alias Smache.Cache.Shard.Model, as: Shard
  alias Smache.Cmd.Model, as: Cmd

  use SmacheWeb, :controller

  @ets_tables Shard.shard_count_tables(:ets)

  def show(conn, %{"id" => id} = _params) do
    if is_nil(id) do
      conn
        |> put_status(500)
        |> json(%{message: "ID cannot be null"})
    end

    json(conn, %{id: is_num_or_str?(id), data: is_num_or_str?(id) |> data()})
  end

  def create_or_update(conn, %{"id" => id, "data" => data} = _params) do
    if is_nil(id) do
      conn
        |> put_status(500)
        |> json(%{message: "ID cannot be null"})
    end

    {uid, table} = ets_table(id)

    json(conn, fetch(uid, data, table))
  end

  def cmd(conn, %{"id" => id, "cmd" => cmd} = _params) do
    if is_nil(id) do
      conn
        |> put_status(500)
        |> json(%{message: "ID cannot be null"})
    end

    %{"query" => query, "keys" => keys} = cmd

    case Cmd.exe(query, keys, data(id)) do
      :error ->
        conn
        |> put_status(500)
        |> json(%{message: "#{query} not supported"})

      data ->
        json(conn, data)
    end
  end

  defp fetch(id, data, ets_table) do
    Smache.Ets.Table.fetch(id, data, ets_table)
  end

  defp data(id) do
    {_uid, table} = ets_table(id)

    case :ets.lookup(table, id) do
      [] -> nil
      [{_id, data}] -> data 
    end
  end

  defp ets_table(id) do
    uid = is_num_or_str?(id)
    shard = rem(uid, length(@ets_tables))

    {uid, Enum.at(@ets_tables, shard)}
  end

  defp is_num_or_str?(id) do
    case is_number(id) do
      true -> id

      false ->
        case is_binary(id) do
          true ->
            hex = Base.encode16(id)
            {num_id, _} = Integer.parse(hex, 16)
            num_id

          false ->
            {num_id, _} = Integer.parse(id)
            num_id
        end
    end
  end
end
