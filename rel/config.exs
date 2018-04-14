Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

{:ok, ifs} = :inet.getif()

(fn ->
  ips =
    Enum.map(ifs, fn {ip, _b, _m} ->
      Enum.join(Tuple.to_list(ip), ".")
    end)

  :os.cmd('echo "-sname \"#{Enum.at(ips, 0)}\"" > #{"./rel/vm.args"}')
end)

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"wow"
  set erl_opts: "-kernel inet_dist_listen_min 9001 inet_dist_listen_max 9001"
end

release :smache do
  set version: current_version(:smache)
  set applications: [
    :runtime_tools
  ]
end
