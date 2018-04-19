defmodule Yo do
  use GenServer

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
    {:reply, post(name), state}
  end

  def post(name) do
    case lookup_synced() do
      [] ->
        update?([], name)
        
      [{_, names}] ->
        update?(names, name)
    end
  end

  defp update?(names, name) do
    case Enum.any?(names, &(&1 == name)) do
      true ->
        grab_active_node_names()
      
      false ->
        synced = names ++ [name]

        true = :ets.insert(:node_names, {:synced, synced})

        grab_active_node_names()
      end
  end

  defp update_all_node_names(names) do
    true = :ets.insert(:node_names, {:synced, names})
  end

  defp grab_active_node_names() do
    [{_, active_node_names}] = lookup_synced()

    active_node_names
  end

  defp lookup_synced() do
    :ets.lookup(:node_names, :synced)
  end

  defp schedule_work() do   
    Yo.post(:"foo@macdev")
    
    grab_active_node_names()
    |> Enum.map(&Task.async(fn -> Node.ping(&1) end))
    |> Enum.map(&(Task.await(&1) == :ping))
    |> Enum.zip(grab_active_node_names())
    |> Enum.filter(fn {up, _name} -> up == :true end)
    |> Enum.map(fn {_up, name} -> name end)
    |> update_all_node_names
    
    Process.send_after(self(), :work, 100)
  end
end
