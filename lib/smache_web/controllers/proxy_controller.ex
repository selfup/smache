defmodule SmacheWeb.ProxyController do
  use SmacheWeb, :controller

  @smache_ips [
    {"192.168.1.7:1234/api/", :first_pool},
    {"192.168.1.7:1235/api/", :second_pool},
    {"192.168.1.7:1236/api/", :third_pool},
    {"192.168.1.7:1237/api/", :fourth_pool},
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
        
        res = Jason.decode!(body)

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
