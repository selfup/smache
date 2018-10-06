defmodule SmacheWeb.PubSub do
  use Phoenix.Channel

  alias Smache.Normalizer, as: Normalizer
  alias Smache.Mitigator, as: Mitigator

  def join("room:subscribe" <> _key, _message, socket) do
    {:ok, socket}
  end

  def join("room:init", _message, socket) do
    {:ok, socket}
  end

  def join("room:*" <> _scoped_subscribe, _message, socket) do
    {:ok, socket}
  end

  def handle_in("subscribe", %{"body" => body}, socket) do
    %{"key" => key, "data" => data} = body

    update =
      Normalizer.normalize(key)
      |> Mitigator.fetch(data)

    broadcast!(socket, "subscribe", %{key: key, payload: update})

    {:noreply, socket}
  end

  def handle_in("init", %{"body" => body}, socket) do
    %{"key" => key} = body

    {_node, data} =
      Normalizer.normalize(key)
      |> Mitigator.grab_data

    broadcast!(socket, "init", %{key: key, payload: data})

    {:noreply, socket}
  end

  def handle_in(scoped_subscribe, %{"body" => body}, socket) when scoped_subscribe =~ "subscribe" do
    %{"key" => key, "data" => data} = body

    update =
      Normalizer.normalize(key)
      |> Mitigator.fetch(data)

    broadcast!(socket, scoped_room, %{key: key, payload: update})

    {:noreply, socket}
  end

  def handle_in(scoped_init, %{"body" => body}, socket) do
    %{"key" => key, "data" => data} = body

    update =
      Normalizer.normalize(key)
      |> Mitigator.fetch(data)

    broadcast!(socket, scoped_room, %{key: key, payload: update})

    {:noreply, socket}
  end
end
