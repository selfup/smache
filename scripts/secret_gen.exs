defmodule Secret do
  @moduledoc """
  Secret was written in Non Compiled Elixir for the following reasons:

  1. High entropy secret generation in bash only works on Linux
  2. Almost works all the way on macOS - but doesn't
  3. Git Bash for Windows (not WSL) doesn't support much
  4. You need Elixir for this project - therefore this will work

  To run: `elixir ./scripts/secret_gen.exs`

  This file is run by other scripts - no real need to run this manually
  """

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
