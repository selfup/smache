use Mix.Config

config :smache, SmacheWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :smache, SmacheWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/smache_web/views/.*(ex)$},
      ~r{lib/smache_web/templates/.*(eex)$}
    ]
  ]

config :logger, level: :warn

config :phoenix, :stacktrace_depth, 20
