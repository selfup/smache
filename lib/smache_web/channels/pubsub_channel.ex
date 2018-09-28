defmodule SmacheWeb.PubSub do
  use Phoenix.Channel

  alias Smache.Normalizer, as: Normalizer
  alias Smache.Mitigator, as: Mitigator

  def join("room:all" <> _key, _message, socket) do
    {:ok, socket}
  end

  def join("room:players", _message, socket) do
    {:ok, socket}
  end

  def handle_in("sync", %{"body" => body}, socket) do
    %{"key" => key, "data" => data} = body

    update =
      Normalizer.normalize(key)
      |> Mitigator.fetch(data)

    broadcast!(socket, "sync", %{key: key, payload: update})

    {:noreply, socket}
  end

  def handle_in("players", %{"body" => body}, socket) do
    %{"key" => key} = body

    {_node, data} =
      Normalizer.normalize(key)
      |> Mitigator.grab_data

    broadcast!(socket, "players", %{key: key, payload: data})

    {:noreply, socket}
  end
end
