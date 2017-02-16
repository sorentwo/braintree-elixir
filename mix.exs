defmodule Braintree.Mixfile do
  use Mix.Project

  @version "0.7.0"

  def project do
    [app: :braintree,
     version: @version,
     elixir: "~> 1.4",
     elixirc_paths: ["lib"],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     description: description(),
     package: package(),

     name: "Braintree",

     deps: deps(),
     docs: docs()]
  end

  def application do
    [applications: [:logger, :hackney, :xmerl]]
  end

  defp description do
    """
    Native Braintree client library for Elixir
    """
  end

  defp package do
    [maintainers: ["Parker Selbert"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/sorentwo/braintree-elixir"},
     files: ~w(lib priv mix.exs README.md CHANGELOG.md)]
  end

  defp deps do
    [{:hackney, "~> 1.6"},

     {:ex_doc, ">= 0.0.0", only: :dev},
     {:inch_ex, ">= 0.0.0", only: :dev},
     {:credo, "~> 0.3", only: :dev}]
  end

  defp docs do
    [main: "readme",
     formatter_opts: [gfm: true],
     source_ref: @version,
     source_url: "https://github.com/sorentwo/braintree-elixir",
     extras: [
       "CHANGELOG.md",
       "README.md"
    ]]
  end
end
