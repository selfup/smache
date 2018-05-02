defmodule Downlink.Server do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    register()

    {:ok, state}
  end

  defp register do
    uplink_node? = System.get_env("UPLINK_NODE")

    uplink_node =
      case uplink_node? do
        nil -> "nonode@nohost"
        long_name -> long_name
      end

    GenServer.call({Uplink, :"#{uplink_node}"}, {:sync, {}})
  end
end
