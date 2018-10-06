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

    post("/", ApiController, :put_or_post)

    get("/", ApiController, :get)
  end

  scope "/healthcheck", SmacheWeb do
    pipe_through(:api)

    get("/", HealthCheckController, :get)
  end
end
