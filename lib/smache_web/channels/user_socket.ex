defmodule SmacheWeb.UserSocket do
  use Phoenix.Socket

  channel("room:*", SmacheWeb.PubSub)

  transport(:websocket, Phoenix.Transports.WebSocket)
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
