defmodule SmacheWeb.PubSub do
  @moduledoc"""
  The SmacheWeb.PubSub module is the generic websocket interface
  """

  use Phoenix.Channel

  alias Smache.Normalizer, as: Normalizer
  alias Smache.Mitigator, as: Mitigator

  @doc"""
  Join any room you want

  Handle the namespacing logic clientside

  The rest is easy peasy!
  """
  def join("room:" <> _any, _message, socket) do
    {:ok, socket}
  end

  @doc"""
  Pass an event name

  Cannot use snake_case for event names
  Must include snake_case for the event type

  Example: myroomname_sub
  Example: myroomname_pub
  Example: asdf1234_sub
  Example: asdf1234_pub
  Example: myRoomName_sub
  Example: myRoomName_pub

  If you include _sub in your events it will behave like a sub hook
  To discover intial state, push to a *_sub channel with a key

  If you include _pub in your events it will behave like a *_pub hook
  All new published data will be recieved on a *_sub hook
  """
  def handle_in(event, %{"body" => body}, socket) do
    cond do
      event =~ "_pub" ->
        pub_to_sub(event) |> update(body, socket)

      event =~ "_sub" ->
        get(event, body, socket)

      true ->
        {:noreply, socket}
    end
  end

  defp pub_to_sub(event) do
    name = event |> String.split("_") |> Enum.at(0)

    name <> "_sub"
  end

  defp get(event, body, socket) do
    %{"key" => key} = body

    {_node, data} =
      Normalizer.normalize(key)
      |> Mitigator.get_data()

    broadcast!(socket, event, %{key: key, data: data})

    {:noreply, socket}
  end

  defp update(event, body, socket) do
    %{"key" => key, "data" => update} = body

    data =
      Normalizer.normalize(key)
      |> Mitigator.put_or_post(update)

    broadcast!(socket, event, %{key: key, data: data})

    {:noreply, socket}
  end
end
