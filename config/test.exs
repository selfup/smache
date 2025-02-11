import Config

config :smache, SmacheWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn
