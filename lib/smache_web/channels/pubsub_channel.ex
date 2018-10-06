defmodule SmacheWeb.PubSub do
  use Phoenix.Channel

  alias Smache.Normalizer, as: Normalizer
  alias Smache.Mitigator, as: Mitigator

  # subscribe to all new data updates  
  def join("room:subscribe" <> _key, _message, socket) do
    {:ok, socket}
  end

  # on initial join, ask for current state without updating
  def join("room:init", _message, socket) do
    {:ok, socket}
  end

  # pass a scoped name or a scope subscription name
  def join("room:*" <> _scoped_subscribe, _message, socket) do
    {:ok, socket}
  end

  # subscribe to all new data updates  
  def handle_in("subscribe", %{"body" => body}, socket) do
    update(body, "subscribe", socket)
  end

  # on initial join, ask for current state without updating
  def handle_in("init", %{"body" => body}, socket) do
    get(body, "init", socket)
  end

  # pass a scoped name or a scope subscription name
  def handle_in(scoped, %{"body" => body}, socket) do
    case scoped =~ "subscribe" do
      true ->
        update(body, scoped, socket)

      false ->
        get(body, scoped, socket)
    end
  end

  # read only
  defp get(body, room, socket) do
    %{"key" => key} = body

    {_node, data} =
      Normalizer.normalize(key)
      |> Mitigator.grab_data()

    broadcast!(socket, room, %{key: key, payload: data})

    {:noreply, socket}
  end

  # read or update
  defp update(body, room, socket) do
    %{"key" => key, "data" => data} = body

    update =
      Normalizer.normalize(key)
      |> Mitigator.fetch(data)

    broadcast!(socket, room, %{key: key, payload: update})

    {:noreply, socket}
  end
end
