defmodule Smache.DiscoverNodes do
  use GenServer

  @sync_dir "/tmp/sync_dir/"

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

    active_nodes =
      check_nodes()
      |> Enum.filter(fn {name, up} -> up end)

    true = :ets.insert(:nodes, {:active_nodes, active_nodes})

    Process.send_after(self(), :work, 1000)
  end

  defp register_self do
    File.mkdir_p(@sync_dir)

    {:ok, file} = File.open(path(), [:write])

    IO.binwrite(file, to_string(Time.utc_now()))

    File.close(file)
  end

  defp path do
    @sync_dir <> Atom.to_string(Node.self())
  end

  defp check_nodes do
    tracked_nodes()
    |> Enum.map(&String.to_atom(&1))
    |> Enum.map(&{&1, Node.ping(&1) == :pong})
  end

  defp tracked_nodes do
    {:ok, nodes} = File.ls(@sync_dir)

    nodes
  end
end
