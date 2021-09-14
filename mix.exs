defmodule Solicit.MixProject do
  use Mix.Project

  @version "1.1.0"

  def project do
    [
      app: :solicit,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      dialyzer: dialyzer(Mix.env()),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application, do: [extra_applications: []]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.5", only: [:test, :dev], runtime: false},
      {:dialyxir, "~> 1.0", only: [:test, :dev], runtime: false},
      {:ecto, "~> 3.6"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:git_hooks, "~> 0.6", only: [:test, :dev], runtime: false},
      {:git_ops, "~> 2.4", only: [:dev], runtime: false},
      {:jason, "~> 1.0"},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
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

  defp dialyzer(:dev), do: dialyzer()
  defp dialyzer(_), do: dialyzer() ++ [plt_core_path: "_build"]

  defp dialyzer() do
    [
      flags: [:unmatched_returns, :error_handling, :race_conditions]
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
