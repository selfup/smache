defmodule SmacheWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :smache

  socket("/socket", SmacheWeb.UserSocket,
    websocket: true,
    longpoll: [check_origin: false]
  )

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
end
