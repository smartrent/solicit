defmodule Solicit.MixProject do
  use Mix.Project

  @version "1.0.15"

  def project do
    [
      app: :solicit,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      dialyzer: dialyzer(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application, do: [extra_applications: []]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:test, :dev], runtime: false},
      {:dialyxir, "~> 1.0.0", only: [:test, :dev], runtime: false},
      {:ecto, "~> 3.4"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:git_hooks, "~> 0.5.0", only: [:test, :dev], runtime: false},
      {:jason, "~> 1.0"},
      {:phoenix_ecto, "~> 4.1"},
      {:phoenix, "~> 1.4"},
      {:plug_cowboy, ">= 1.0.0"},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp aliases() do
    [
      lint: ["credo --strict --ignore Consistency"]
    ]
  end

  defp dialyzer() do
    [
      flags: [:unmatched_returns, :error_handling, :race_conditions],
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp description() do
    "Solicit is an Elixir package that provides basic API Response Handling."
  end

  defp package() do
    [
      # These are the default files included in the package
      organization: "smartrent",
      files: ~w(lib mix.exs README*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/smartrent/solicit"}
    ]
  end
end
