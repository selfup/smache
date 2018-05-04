defmodule SmacheWeb.ApiController do
  alias Smache.Normalizer, as: Normalizer
  alias Smache.Mitigator, as: Mitigator

  use SmacheWeb, :controller

  def show(conn, %{"key" => key} = _params) do
    case key_is_nil?(conn, key) do
      :proceed_with_request ->
        {node, data} =
          Normalizer.normalize(key)
          |> Mitigator.grab_data()

        json(conn, %{
          key: key,
          node: node,
          data: data
        })

      forbidden_key_type_response ->
        forbidden_key_type_response
    end
  end

  def create_or_update(conn, %{"key" => key, "data" => data} = _params) do
    case key_is_nil?(conn, key) do
      :proceed_with_request ->
        ukey = Normalizer.normalize(key)

        json(conn, Mitigator.fetch(ukey, data))

      forbidden_key_type_response ->
        forbidden_key_type_response
    end
  end

  defp key_is_nil?(conn, key) do
    case is_nil(key) do
      true ->
        conn
        |> put_status(403)
        |> json(%{message: "key cannot be null"})

      false ->
        :proceed_with_request
    end
  end
end
