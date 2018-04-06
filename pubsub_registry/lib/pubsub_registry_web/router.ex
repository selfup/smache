defmodule PubsubRegistryWeb.Router do
  use PubsubRegistryWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PubsubRegistryWeb do
    pipe_through :api

    get("/", ApiController, :show)
  end
end
