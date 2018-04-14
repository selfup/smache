defmodule Smache.DiscoverNodes do
  use GenServer

  @sync_dir "/tmp/sync_dir/"

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    sign_as_active_node()

    status =
      check_active_nodes()
      |> Enum.filter(fn {name, up} -> up end)

    IO.inspect(status)

    # every 10 seconds
    Process.send_after(self(), :work, 10 * 1000)
  end

  defp sign_as_active_node do
    File.mkdir_p(@sync_dir)
    {:ok, file} = File.open(path(), [:write])
    IO.binwrite(file, to_string(Time.utc_now()))
    File.close(file)
  end

  defp path do
    @sync_dir <> Atom.to_string(Node.self())
  end

  defp check_active_nodes do
    active_nodes()
    |> Enum.map(&String.to_atom(&1))
    |> Enum.map(&{&1, Node.ping(&1) == :pong})
  end

  defp active_nodes do
    {:ok, active_members} = File.ls(@sync_dir)

    active_members
  end
end
