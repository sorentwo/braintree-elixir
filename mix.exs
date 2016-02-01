defmodule Braintree.Mixfile do
  use Mix.Project

  def project do
    [app: :braintree,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [httpoison: "~> 0.8",
     quinn: "~> 0.0.4"]
  end

  defp aliases do
    ["test.all": "test --include integration"]
  end
end
