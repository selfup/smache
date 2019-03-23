defmodule Smache.Supervisor do
  alias Smache.Ets.Table, as: EtsTable
  alias Downlink.Server, as: Downlink
  alias Uplink.Server, as: Uplink
  alias Operator.Server, as: Operator

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(EtsTable, []),
      worker(Uplink, [UplinkServer]),
      worker(Downlink, [DownlinkServer])
    ]

    operators =
      1..16
      |> Enum.map(fn name ->
        uniq = :"operator_#{name}"
        worker(Operator, [[name: uniq]], id: uniq)
      end)

    all_children = children ++ operators

    supervise(all_children, strategy: :one_for_one)
  end
end
