defmodule SmacheWeb.ProxyController do
  alias Smache.Cache.Shard.Model, as: Shard

  use SmacheWeb, :controller

  @smache_ips [
    "192.168.1.7:1234/api/?key=1",
    "192.168.1.7:1235/api/?key=1",
    "192.168.1.7:1236/api/?key=1",
    "192.168.1.7:1237/api/?key=1",
  ]

  def show(conn, %{"key" => key} = _params) do
    case key_is_nil?(conn, key) do
      :proceed_with_request ->
        url = @smache_ips |> Enum.shuffle |> hd
        headers = []
        params = []

        {:ok,
          %HTTPoison.Response{status_code: 200, body: body}
        } = HTTPoison.get(url, headers, params: params)
        
        {:ok, res} = Poison.decode(body)

        json(conn, res)

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
