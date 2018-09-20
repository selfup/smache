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
    :os.cmd(:"nslookup #{name} | grep Address | head -2 | tail -1 | cut -d \":\" -f 2 | tr -d \" \"")
    |> to_string
    |> String.replace("\n", "")
    |> String.replace(" ", "")
  end

  def resolved_node do
    case find_dns("smachenode") =~ "null" do
      true -> nil
      false -> "smache@#{resolved_node}"
    end
  end

  defp register do
    node = :"#{resolved_node() || Node.self()}"

    Logger.warn("self: #{Node.self()} - uplink: #{node}")

    GenServer.call({Uplink, node}, {:sync, {}})
  end
end
