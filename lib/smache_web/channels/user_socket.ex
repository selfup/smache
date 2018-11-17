defmodule SmacheWeb.UserSocket do
  use Phoenix.Socket

  channel("room:*", SmacheWeb.PubSub)

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
