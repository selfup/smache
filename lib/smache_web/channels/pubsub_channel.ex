defmodule SmacheWeb.PubSub do
  use Phoenix.Channel

  alias Smache.Normalizer, as: Normalizer
  alias Smache.Mitigator, as: Mitigator

  def join("room:all" <> _key, _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _key, _message, socket) do
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
end
