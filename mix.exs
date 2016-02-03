defmodule Braintree.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :braintree,
     version: @version,
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     aliases: aliases,
     deps: deps,

     name: "Braintree",
     source_url: "https://github.com/sorentwo/braintree",
     docs: [source_ref: "v#{@version}", main: "Braintree"]]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [{:httpoison, "~> 0.8"},
     {:ex_doc, "~> 0.11", only: :dev},
     {:earmark, "~> 0.2", only: :dev}
   ]
  end

  defp aliases do
    ["test.all": "test --include integration"]
  end
end
