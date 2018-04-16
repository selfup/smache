defmodule Smache.Ets.Table do
  alias Smache.Cache.Model, as: Model

  use GenServer

  def start_link(opts \\ []) do
    [name: name] = opts

    GenServer.start_link(
      __MODULE__,
      [
        {:name, name}
      ],
      opts
    )
  end

  def fetch(id, data, ets_table) do
    GenServer.call(ets_table, {:fetch, {id, data, ets_table}})
  end

  def handle_call({:fetch, {id, data, ets_table}}, _from, state) do
    {:reply, Model.fetch(id, data, ets_table), state}
  end

  def init(args) do
    [{:name, name}] = args

    :ets.new(name, [
      :named_table,
      :set,
      :public,
      read_concurrency: true
    ])

    {:ok, %{name: name}}
  end
end
