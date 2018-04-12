defmodule SmacheWeb.HealthCheckController do
  use SmacheWeb, :controller

  def get(conn, _params) do
    json(conn, %{})
  end
end
