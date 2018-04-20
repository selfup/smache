defmodule Smache.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    case System.get_env("YO") do
      "true" ->
        Yo.Supervisor.start_link(name: Yo.Supervisor)

      _yo_var_not_set ->
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
  end

  def config_change(changed, _new, removed) do
    SmacheWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
