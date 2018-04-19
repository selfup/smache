defmodule Yo do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    :ets.new(:yo_nodes, [
      :named_table,
      :set,
      :public,
      read_concurrency: true
    ])

    :ets.insert(:yo_nodes, {:synced, []})

    schedule_work()

    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  def handle_call({:yo, {name}}, _from, state) do
    {:reply, yo(name), state}
  end

  def yo(name) do
    case :ets.lookup(:yo_nodes, :synced) do
      [] ->
        true = :ets.insert(:yo_nodes, {:synced, [name]})
        
      [{_, names}] ->
        update?(names, name)
    end
  end

  def update?(names, name) do
    case Enum.any?(names, &(&1 == name)) do
      true ->
        :already_in
      
      false ->
        synced = names ++ [name]

        true = :ets.insert(:yo_nodes, {:synced, synced})

        :updated
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1000)
  end
end
