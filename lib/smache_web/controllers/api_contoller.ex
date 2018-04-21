defmodule SmacheWeb.ApiController do
  alias Smache.Cache.Shard.Model, as: Shard
  alias Smache.Mitigator, as: Mitigator

  use SmacheWeb, :controller

  def show(conn, %{"key" => key} = _params) do
    case key_is_nil?(conn, key) do
      :proceed_with_request ->
        valid_key = Shard.is_num_or_str?(key)

        {node, valid_data} =
          valid_key
          |> Mitigator.grab_data()

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
        {ukey, table} = Mitigator.ets_table(key)

        json(conn, Mitigator.fetch(ukey, data, table))

      forbidden_key_type_response ->
        forbidden_key_type_response
    end
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
