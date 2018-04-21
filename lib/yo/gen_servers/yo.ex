defmodule Yo do
  use GenServer

  alias Yo.Delegator, as: Delegator

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

  def handle_call({:yo, {name}}, _from, state) do
    {:reply, Delegator.post(name), state}
  end

  defp schedule_work() do
    Delegator.sync()
    Process.send_after(self(), :work, 1000)
  end
end
