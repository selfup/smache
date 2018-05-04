defmodule Downlink.Server do
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: Downlink)
  end

  def init(_state) do
    register()

    {:ok, %{}}
  end

  defp register do
    node = :"#{System.get_env("UPLINK_NODE") || Node.self()}"

    Logger.warn "self: #{Node.self()} - uplink: #{node}"

    GenServer.call({Uplink, node}, {:sync, {}})
  end
end
