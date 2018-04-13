{:ok, ifs} = :inet.getif()

ips =
  Enum.map(ifs, fn {ip, _b, _m} ->
    Enum.join(Tuple.to_list(ip), ".")
  end)

:os.cmd('echo "-sname #{Enum.at(ips, 0)}" > #{"./rel/vm.args"}')
