defmodule Downlink.Server do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    :ets.new(:downlink, [
      :named_table,
      :set,
      :public,
      read_concurrency: true
    ])

    Downlink.Operator.sync([])

    register()

    {:ok, state}
  end

  defp register do
    if !System.get_env("UPLINK") do
      mit = System.get_env("MITIGATOR")
      Node.ping(:"#{mit}")
    end
  end
end
