defmodule Braintree.HTTP do
  @moduledoc """
  Base client for all server interaction, used by all endpoint specific
  modules. This request wrapper coordinates the remote server, headers,
  authorization and SSL options.

  Using `Braintree.HTTP` requires the presence of three config values:

  * merchant_id - Braintree merchant id
  * private_key - Braintree private key
  * public_key - Braintree public key

  All three must have values set or a `Braintree.ConfigError` will be raised
  at runtime. All those config values support the `{:system, "VAR_NAME"}`
  as a value - in that case the value will be read from the system environment
  with `System.get_env("VAR_NAME")`.
  """

  require Logger

  alias Braintree.XML.{Decoder, Encoder}
  alias Braintree.ErrorResponse, as: Error

  @endpoints [
    production: "https://api.braintreegateway.com/merchants/",
    sandbox: "https://api.sandbox.braintreegateway.com/merchants/"
  ]

  @cacertfile "/certs/api_braintreegateway_com.ca.crt"

  @headers [
    {"Accept", "application/xml"},
    {"User-Agent", "Braintree Elixir/0.1"},
    {"Accept-Encoding", "gzip"},
    {"X-ApiVersion", "4"},
    {"Content-Type", "application/xml"}
  ]

  @statuses %{
    401 => :unauthorized,
    403 => :forbidden,
    404 => :not_found,
    426 => :upgrade_required,
    500 => :server_error,
    503 => :service_unavailable
  }

  @doc """
  Centralized request handling function. All convenience structs use this
  function to interact with the Braintree servers. This function can be used
  directly to supplement missing functionality.

  ## Example

      defmodule MyApp.Disbursement do
        alias Braintree.HTTP

        def disburse(params \\ %{}) do
          HTTP.request(:get, "disbursements", params)
        end
      end
  """
  @spec request(atom, binary, binary | Map.t, Keyword.t) ::
        {:ok, Map.t | {:error, atom}} | {:error, Error.t} | {:error, binary}
  def request(method, path, body \\ %{}, opts \\ []) do
    response = :hackney.request(method, build_url(path, opts), build_headers(opts), encode_body(body), build_options())

    case response do
      {:ok, code, _headers, body} when code >= 200 and code <= 399 ->
        {:ok, decode_body(body)}
      {:ok, 422, _headers, body} ->
        error =
          body
          |> decode_body()
          |> Map.get("api_error_response")
          |> Error.new()

        {:error, error}
      {:ok, code, _headers, _body} when code >= 401 and code <= 504 ->
        {:error, code_to_reason(code)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  for method <- ~w(get delete post put)a do
    def unquote(method)(path, payload \\ %{}, opts \\ []) do
      request(unquote(method), path, payload, opts)
    end
  end

  ## Helper Functions

  @doc false
  @spec build_url(binary, Keyword.t) :: binary
  def build_url(path, opts) do
    environment = Keyword.get(opts, :environment, Braintree.get_env(:environment, :sandbox))
    merchant_id = Keyword.get(opts, :merchant_id, Braintree.get_env(:merchant_id))

    Keyword.fetch!(@endpoints, environment) <> merchant_id <> "/" <> path
  end

  @doc false
  @spec encode_body(binary | Map.t) :: binary
  def encode_body(body) when body == "" or body == %{}, do: ""
  def encode_body(body), do: Encoder.dump(body)

  @doc false
  @spec decode_body(binary) :: Map.t
  def decode_body(body) do
    body
    |> :zlib.gunzip()
    |> String.trim()
    |> Decoder.load()
  rescue
    ErlangError -> Logger.error("unprocessable response")
  end

  @doc false
  @spec basic_auth(binary, binary) :: binary
  def basic_auth(user, pass) do
    "Basic " <> :base64.encode("#{user}:#{pass}")
  end

  @doc false
  @spec build_headers(Keyword.t) :: [tuple]
  def build_headers(opts) do
    public  = Keyword.get(opts, :public_key, Braintree.get_env(:public_key))
    private = Keyword.get(opts, :private_key, Braintree.get_env(:private_key))

    [{"Authorization", basic_auth(public, private)} | @headers]
  end

  @doc false
  @spec build_options() :: [...]
  def build_options do
    cacertfile = Path.join(:code.priv_dir(:braintree), @cacertfile)
    http_opts = Braintree.get_env(:http_options, [])

    [:with_body, ssl_options: [cacertfile: cacertfile]] ++ http_opts
  end

  @doc false
  @spec code_to_reason(integer | atom) :: integer
  def code_to_reason(integer)

  for {code, status} <- @statuses do
    def code_to_reason(unquote(code)), do: unquote(status)
  end
end
