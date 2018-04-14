defmodule Secret do
  def create_sha do
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
