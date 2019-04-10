defmodule Smache.Ets.Table do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: SmacheCache)
  end

  def init(_args) do
    :ets.new(:smache_cache, [
      :named_table,
      :set,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])

    {:ok, %{}}
  end
end
