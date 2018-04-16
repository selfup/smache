defmodule Secret do
  def create_sha do
    <<
      i1 :: unsigned-integer-32,
      i2 :: unsigned-integer-32,
      i3 :: unsigned-integer-32,
    >> = :crypto.strong_rand_bytes(12)
    
    :rand.seed(:exsplus, {i1, i2, i3})

    rand = to_string(:rand.uniform())
    :crypto.hash(:sha256, rand) |> Base.encode16
  end

  def write_secret do
    secret = "export SECRET_KEY_BASE=#{create_sha()}#{create_sha()}\n"
    cookie = "export COOKIE=#{create_sha()}\n"
    File.write!(".env", secret <> cookie)
  end
end

Secret.write_secret()
