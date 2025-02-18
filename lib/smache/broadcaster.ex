defmodule Smache.Broadcaster do
  require Logger
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # Schedule work to be performed at some point
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    host = SmacheWeb.Endpoint.host()
    url = SmacheWeb.Endpoint.url()
    port = System.get_env("PORT")

    Logger.warning("host: #{host} - port: #{port} - url: #{url}")

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 10000)
  end
end
