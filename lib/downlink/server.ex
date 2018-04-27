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

    IO.puts "REGISTER CALLED"

    {:ok, state}
  end

  defp register do
    mit = System.get_env("MITIGATOR") || nil
    IO.inspect(
      :rpc.call(:"#{mit}", Uplink.Operator, :post, [Node.self()])
    )
  end
end
