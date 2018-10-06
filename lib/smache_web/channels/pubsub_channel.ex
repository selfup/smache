defmodule SmacheWeb.PubSub do
  use Phoenix.Channel

  alias Smache.Normalizer, as: Normalizer
  alias Smache.Mitigator, as: Mitigator

  def join(_room, _message, socket) do
    {:ok, socket}
  end

  # pass an event name
  # cannot use snake_case for event names but must include snake_case
  # to help identify if the event is pub or sub
  # Example: myroomname_sub
  # Example: myroomname_pub
  # Example: asdf1234_sub
  # Example: asdf1234_pub
  # Example: myRoomName_sub
  # Example: myRoomName_pub
  #
  # if you include _sub in your events it will behave like a sub hook
  # to discover intial state push to a *_sub channel with a key
  #
  # if you include _pub in your events it will behave like a *_pub hook
  # all new data pushed should/will be listened to on *_sub
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

  defp pub_to_sub(room) do
    name = room |> String.split("_") |> Enum.at(0)

    name <> "_sub"
  end

  # read only
  defp get(body, room, socket) do
    %{"key" => key} = body

    {_node, data} =
      Normalizer.normalize(key)
      |> Mitigator.grab_data()

    broadcast!(socket, room, %{key: key, data: data})

    {:noreply, socket}
  end

  # read if no change or update if there is a change
  defp update(body, room, socket) do
    %{"key" => key, "data" => update} = body

    data =
      Normalizer.normalize(key)
      |> Mitigator.put_or_post(update)

    broadcast!(socket, room, %{key: key, data: data})

    {:noreply, socket}
  end
end
