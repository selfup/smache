defmodule SmacheWeb.Router do
  use SmacheWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", SmacheWeb do
    pipe_through(:api)

    post("/", ApiController, :create_or_update)

    get("/", ApiController, :show)
    get("/cmd", ApiController, :cmd)
  end
end
