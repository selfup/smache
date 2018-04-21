defmodule Yo do
  use GenServer

  alias Yo.Mitigator, as: Mitigator

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    :ets.new(:node_names, [
      :named_table,
      :set,
      :public,
      read_concurrency: true
    ])

    :ets.insert(:node_names, {:synced, []})

    schedule_work()

    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Mitigator.sync()

    if System.get_env("YO") == "true" do
      Process.send_after(self(), :work, 300)
    end
  end
end
