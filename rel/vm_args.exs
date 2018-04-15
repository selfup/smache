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

IO.puts "export SNAME_IP=#{name}@#{ip} export COOKIE=#{cookie}"
