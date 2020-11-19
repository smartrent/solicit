defmodule Solicit.MixProject do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :solicit,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application, do: [extra_applications: []]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.4"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:jason, "~> 1.0"},
      {:phoenix_ecto, "~> 4.1.0"},
      {:phoenix, "~> 1.4"},
      {:plug_cowboy, "~> 1.0"},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end
