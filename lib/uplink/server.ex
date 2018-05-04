defmodule Uplink.Server do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: Uplink)
  end

  def init(_state) do
    {:ok, %{}}
  end

  def handle_call({:sync, _}, _, _) do
    {:reply, :ok, %{}}
  end
end
