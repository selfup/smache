{:ok, ifs} = :inet.getif()

name =
  :crypto.hash(:sha256, to_string(:rand.uniform()))
  |> Base.encode16
  |> String.slice(0..10)
  |> String.downcase

ips =
  Enum.map(ifs, fn {ip, _b, _m} ->
    Enum.join(Tuple.to_list(ip), ".")
  end)

ip = ips |> Enum.at(0)

cookie =
  File.read!(".env")
  |> String.split("\n")
  |> Enum.at(1)
  |> String.split("=")
  |> Enum.at(1)

System.put_env("SNAME_IP", "#{name}@#{ip}")
System.put_env("REPLACE_OS_VARS", "true")
System.put_env("COOKIE", cookie)

IO.inspect System.get_env("SNAME_IP")
IO.inspect System.get_env("REPLACE_OS_VARS")
IO.inspect System.get_env("COOKIE")
