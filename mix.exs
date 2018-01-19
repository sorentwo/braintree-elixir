defmodule Braintree.Mixfile do
  use Mix.Project

  @version "0.9.0"

  def project do
    [
      app: :braintree,
      version: @version,
      elixir: "~> 1.5",
      elixirc_paths: ["lib"],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      description: description(),
      package: package(),
      name: "Braintree",
      deps: deps(),
      docs: docs(),
      dialyzer: [
        plt_add_deps: :transitive,
        flags: [:unmatched_returns, :error_handling]
      ]
    ]
  end

  def application do
    [
      applications: [:logger, :hackney, :xmerl],
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
      {:hackney, "~> 1.6"},
      {:credo, "~> 0.8", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.18", only: [:dev], runtime: false},
      {:inch_ex, "~> 0.5", only: [:dev], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.8", only: [:dev, :test]}
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
