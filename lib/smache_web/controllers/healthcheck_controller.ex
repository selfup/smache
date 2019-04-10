defmodule SmacheWeb.HealthCheckController do
  use SmacheWeb, :controller

  def get(conn, _params) do
    conn |> json(%{})
  end
end
