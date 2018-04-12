defmodule SmacheWeb.ProxyController do
  use SmacheWeb, :controller

  @smache_ips [
    {"172.17.0.1:1234/api/", :first_pool},
    {"172.17.0.1:1235/api/", :second_pool},
    {"172.17.0.1:1236/api/", :third_pool},
    {"172.17.0.1:1237/api/", :fourth_pool},
  ]

  def get(conn, %{"key" => key} = _params) do
    case key_is_nil?(conn, key) do
      :proceed_with_request ->
        [url_info | _t] = @smache_ips |> Enum.shuffle

        headers = []
        params = [key: key]

        {url, pool} = url_info

        {:ok,
          %HTTPoison.Response{status_code: 200, body: body}
        } = HTTPoison.get(url, headers, params: params, hackney: [pool: pool])
        
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
