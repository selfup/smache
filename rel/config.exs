Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

# :os.cmd('./local_scripts/generate_vm_args.sh')

{:ok, ifs} = :inet.getif()

ips =
  Enum.map(ifs, fn {ip, _b, _m} ->
    Enum.join(Tuple.to_list(ip), ".")
  end)

:os.cmd('echo "-sname \"#{Enum.at(ips, 0)}\"" > #{"./rel/vm.args"}')

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"wow"
  # set vm_args: "./rel/vm.args"
  set erl_opts: "-kernel inet_dist_listen_min 9001 inet_dist_listen_max 9001"
end

release :smache do
  set version: current_version(:smache)
  set applications: [
    :runtime_tools
  ]
end
