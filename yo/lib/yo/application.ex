defmodule Yo.Application do
  use Application

  def start(_type, _args) do
    Yo.Supervisor.start_link(name: Yo.Supervisor)
  end
end
