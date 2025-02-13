defmodule Smache.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, [name: Smache.PubSub, adapter: Phoenix.PubSub.PG2]},
      {SmacheWeb.Endpoint, []},
      {Smache.Supervisor, []}
    ]

    opts = [
      strategy: :one_for_one,
      name: Smache.Main.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    SmacheWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
