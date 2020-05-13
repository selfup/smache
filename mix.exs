defmodule Smache.Mixfile do
  use Mix.Project

  def project do
    [
      app: :smache,
      version: System.get_env("VERSION") || "0.0.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Smache.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.5.1"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:distillery, "~> 2.1.1", runtime: true, only: :prod}
    ]
  end
end
