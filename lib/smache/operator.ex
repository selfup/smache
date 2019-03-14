defmodule Operator.Server do
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

  def init(_state) do
    {:ok, %{}}
  end

  def handle_call({:put_or_post, {key, data}}, _, _) do
    {:reply, Smache.Cache.put_or_post(key, data), %{}}
  end

  def handle_call({:get, {key}}, _, _) do
    {:reply, Smache.Mitigator.get(key), %{}}
  end
end
