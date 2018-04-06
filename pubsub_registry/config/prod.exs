use Mix.Config

config :pubsub_registry, PubsubRegistryWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "http"],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  server: true

  config :logger, level: :warn
