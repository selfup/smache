Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"Lo)lqpD/B<w4=]adsfasdfasdfasdfw6gKMxMP!%~:C|neoXTN}87UU)hRrtVQfb9o|_QNd%:ZY[9{tx"
end

release :pubsub_registry do
  set version: current_version(:pubsub_registry)
  set applications: [
    :runtime_tools
  ]
end
