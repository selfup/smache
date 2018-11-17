defmodule SmacheWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :smache

  socket("/socket", SmacheWeb.UserSocket,
    websocket: true,
    longpoll: [check_origin: false])

  if code_reloading? do
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(
    Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)
  plug(SmacheWeb.Router)

  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "PLZ SET $PORT ENV VAR"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
