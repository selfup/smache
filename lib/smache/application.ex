defmodule Smache.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(SmacheWeb.Endpoint, []),
      supervisor(Smache.Supervisor, [])
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
