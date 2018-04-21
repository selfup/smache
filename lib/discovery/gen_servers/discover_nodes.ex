defmodule Smache.DiscoverNodes do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    :ets.new(:nodes, [
      :named_table,
      :set,
      :public,
      read_concurrency: true
    ])

    schedule_work()

    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    register_self()
  end

  def get_updated_nodes(active_nodes) do
    true = :ets.insert(:nodes, {:active_nodes, active_nodes})
  end

  defp register_self do
    mitigator = System.get_env("MITIGATOR")

    case mitigator == to_string(Node.self()) do
      true ->
        {:ok, _} = :rpc.call(:"#{mitigator}", Yo.Mitigator, :post, [Node.self()])

      false ->
        {:ok, nil}
    end
  end
end
