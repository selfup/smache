use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pubsub_registry, PubsubRegistryWeb.Endpoint,
  http: [port: 4003],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
