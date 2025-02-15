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

  def find_dns(name) do
    uplink_provided = System.get_env("UPLINK_NODE")

    if uplink_provided != nil do
      uplink_provided
    else
      :os.cmd(
        :"nslookup #{name} | grep 'Address: ' | head -2 | tail -1 | tr -d 'Address: ' | tr -d '\n'"
      )
      |> to_string
    end
  end

  def resolved_node do
    uplink_node = find_dns("uplink")

    test_mode = System.get_env("TEST")

    if test_mode == "1", do: nil, else: "smache@#{uplink_node}"
  end

  defp register do
    node = :"#{resolved_node()}"

    Logger.warning("self: #{Node.self()} - uplink: #{node}")

    if node != :"" do
      GenServer.call({Uplink, node}, {:sync, {}})
    end
  end
end
