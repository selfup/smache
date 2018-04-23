defmodule Downlink.Server do
  use GenServer

  alias Uplink.Operator, as: Operator

  @mitigator System.get_env("MITIGATOR") || nil

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
    :rpc.call(:"#{@mitigator}", Operator, :post, [Node.self()])
  end
end
