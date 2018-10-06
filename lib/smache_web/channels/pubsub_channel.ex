defmodule SmacheWeb.PubSub do
  use Phoenix.Channel

  alias Smache.Normalizer, as: Normalizer
  alias Smache.Mitigator, as: Mitigator

  # sync to all new data updates  
  def join("room:sync" <> _key, _message, socket) do
    {:ok, socket}
  end

  # on initial join, ask for current state without updating
  def join("room:join", _message, socket) do
    {:ok, socket}
  end

  # pass a scoped name or a scope subscription name
  def join("room:*" <> _scoped, _message, socket) do
    {:ok, socket}
  end

  # sync to all new data updates  
  def handle_in("sync", %{"body" => body}, socket) do
    update(body, "sync", socket)
  end

  # on initial join, ask for current state without updating
  def handle_in("join", %{"body" => body}, socket) do
    get(body, "join", socket)
  end

  # pass a scoped name or a scope subscription name
  # if you include the word 'sync' in your room
  # it will behave like a sync hook
  # otherwise it will behave like a join hook
  def handle_in(scoped, %{"body" => body}, socket) do
    case scoped =~ "sync" do
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

  # read if no change or update if there is a change
  defp update(body, room, socket) do
    %{"key" => key, "data" => data} = body

    update =
      Normalizer.normalize(key)
      |> Mitigator.fetch(data)

    broadcast!(socket, room, %{key: key, payload: update})

    {:noreply, socket}
  end
end
