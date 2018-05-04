{:ok, ifs} = :inet.getif()

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

sname_ip = "smache@#{ip}"

env_vars = [
  "REPLACE_OS_VARS=true",
  "SNAME_IP=#{sname_ip}",
  "COOKIE=#{cookie}",
  "SHARD_LIMIT=20",
]

env_vars
|> Enum.map(&"export #{&1} ")
|> IO.puts
