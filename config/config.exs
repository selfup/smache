# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# Configures the endpoint
config :smache, SmacheWeb.Endpoint,
  url: [host: "0.0.0.0"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [
    formats: [html: Smache.ErrorHTML, json: Smache.ErrorJSON],
    layout: false
  ],
  pubsub_server: Smache.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
