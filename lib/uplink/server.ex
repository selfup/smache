defmodule Uplink.Server do
  use GenServer

  alias Uplink.Operator, as: Operator

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    if System.get_env("UPLINK") do
      schedule_work()
    end

    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Operator.sync()
    Process.send_after(self(), :work, 100)
  end
end
