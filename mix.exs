defmodule Braintree.Mixfile do
  use Mix.Project

  @version "0.5.0"

  def project do
    [app: :braintree,
     version: @version,
     elixir: "~> 1.3",
     elixirc_paths: ["lib"],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     description: description,
     package: package,

     aliases: aliases,
     deps: deps,

     name: "Braintree",
     source_url: "https://github.com/sorentwo/braintree",
     docs: [source_ref: "v#{@version}",
            extras: ["README.md"],
            main: "Braintree"]]
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
     {:ex_doc, "~> 0.11", only: :dev},
     {:earmark, "~> 0.2", only: :dev},
     {:credo, "~> 0.3", only: :dev}]
  end

  defp aliases do
    ["test.all": "test --include integration"]
  end
end
