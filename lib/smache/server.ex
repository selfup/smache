defmodule Smache.Ets.Table do
  alias Smache.Cache, as: Cache

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: SmacheCache)
  end

  def init(_args) do
    :ets.new(:smache_cache, [
      :named_table,
      :set,
      :public,
      read_concurrency: true
    ])

    {:ok, %{}}
  end

  def fetch(id, data) do
    GenServer.call(SmacheCache, {:fetch, {id, data}})
  end

  def handle_call({:fetch, {id, data}}, _from, state) do
    {:reply, Cache.fetch(id, data), state}
  end
end
