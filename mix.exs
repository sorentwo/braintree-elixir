defmodule Braintree.Mixfile do
  use Mix.Project

  def project do
    [app: :braintree,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [httpoison: "~> 0.8",
     quinn: "~> 0.0.4"]
  end
end
