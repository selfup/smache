defmodule SmacheWeb.Router do
  use SmacheWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SmacheWeb do
    pipe_through(:api)

    get("/", HealthCheckController, :get)
  end

  scope "/api", SmacheWeb do
    pipe_through(:api)

    post("/", ApiController, :create_or_update)

    get("/", ApiController, :show)
  end

  scope "/healthcheck", SmacheWeb do
    pipe_through(:api)

    get("/", HealthCheckController, :get)
  end
end
