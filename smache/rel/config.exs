Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"Lo)lqpD/B<w4=]w6gKMxMP!%~:C|neoXTN}87UU)hRrtVQfb9o|_QNd%:ZY[9{tx"
end

release :smache do
  set version: current_version(:smache)
  set applications: [
    :runtime_tools
  ]
end
