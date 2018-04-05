defmodule PubsubRegistryWeb.ApiController do
  use PubsubRegistryWeb, :controller

  def show(conn, %{} = _params) do
    json(conn, %{})
  end
end
