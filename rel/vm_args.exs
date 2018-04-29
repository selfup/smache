<<
  i1 :: unsigned-integer-32,
  i2 :: unsigned-integer-32,
  i3 :: unsigned-integer-32,
>> = :crypto.strong_rand_bytes(12)
    
:rand.seed(:exsplus, {i1, i2, i3})

name =
  :crypto.hash(:sha256, to_string(:rand.uniform()))
  |> Base.encode16
  |> String.slice(0..10)
  |> String.downcase

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

mitigator = System.get_env("MITIGATOR")

sname_ip =
  case System.get_env("VIRTUAL_MITIGATOR") == "true"  do
    true ->
      case System.get_env("VPS") == "true" do
        true -> "#{name}@#{ip}"
        false -> mitigator
      end
    false -> "#{name}@#{ip}"
  end

env_vars = [
  "REPLACE_OS_VARS=true",
  "SNAME_IP=#{sname_ip}",
  "COOKIE=#{cookie}",
  "SHARD_LIMIT=20",
]

env_vars
|> Enum.map(&"export #{&1} ")
|> IO.puts
