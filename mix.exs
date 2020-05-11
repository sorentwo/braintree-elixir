defmodule Braintree.Mixfile do
  use Mix.Project

  @version "0.11.0"

  def project do
    [
      app: :braintree,
      version: @version,
      elixir: "~> 1.5",
      elixirc_paths: ["lib"],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      description: description(),
      package: package(),
      name: "Braintree",
      deps: deps(),
      docs: docs(),
      dialyzer: [
        flags: [:unmatched_returns, :error_handling, :race_conditions]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :xmerl],
      env: [
        environment: :sandbox,
        http_options: [timeout: 30_000],
        master_merchant_id: {:system, "BRAINTREE_MASTER_MERCHANT_ID"},
        merchant_id: {:system, "BRAINTREE_MERCHANT_ID"},
        private_key: {:system, "BRAINTREE_PRIVATE_KEY"},
        public_key: {:system, "BRAINTREE_PUBLIC_KEY"}
      ]
    ]
  end

  defp description do
    """
    Native Braintree client library for Elixir
    """
  end

  defp package do
    [
      maintainers: ["Parker Selbert"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sorentwo/braintree-elixir"},
      files: ~w(lib priv mix.exs README.md CHANGELOG.md)
    ]
  end

  defp deps do
    [
      {:hackney, "~> 1.15"},
      {:ex_doc, "~> 0.19", only: [:dev], runtime: false},
      {:inch_ex, "~> 2.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: @version,
      formatter_opts: [gfm: true],
      extras: [
        "CHANGELOG.md",
        "README.md"
      ]
    ]
  end
end
