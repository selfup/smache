defmodule Uplink.Server do
  use GenServer

  alias Uplink.Operator, as: Operator

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    :ets.new(:uplink, [
      :named_table,
      :set,
      :public,
      read_concurrency: true
    ])

    :ets.insert(:uplink, {:synced, []})

    schedule_work()

    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    if System.get_env("UPLINK") == "true" do
      Operator.sync()
      Process.send_after(self(), :work, 16)
    end
  end
end
