defmodule Braintree.HTTP do
  @moduledoc """
  Base client for all server interaction, used by all endpoint specific
  modules.

  This request wrapper coordinates the remote server, headers, authorization
  and SSL options.

  Using `Braintree.HTTP` requires the presence of three config values:

  * `merchant_id` - Braintree merchant id
  * `private_key` - Braintree private key
  * `public_key` - Braintree public key

  All three values must be set or a `Braintree.ConfigError` will be raised at
  runtime. All those config values support the `{:system, "VAR_NAME"}` as a
  value - in which case the value will be read from the system environment with
  `System.get_env("VAR_NAME")`.
  """

  require Logger

  alias Braintree.ErrorResponse, as: Error
  alias Braintree.XML.{Decoder, Encoder}

  @type response ::
          {:ok, map | {:error, atom}}
          | {:error, Error.t()}
          | {:error, binary}

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
    400 => :bad_request,
    401 => :unauthorized,
    403 => :forbidden,
    404 => :not_found,
    422 => :unprocessable_entity,
    426 => :upgrade_required,
    429 => :too_many_requests,
    500 => :server_error,
    503 => :service_unavailable,
    504 => :connect_timeout
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
  @spec request(atom, binary, binary | map, Keyword.t()) :: response
  def request(method, path, body \\ %{}, opts \\ []) do
    response =
      :hackney.request(
        method,
        build_url(path, opts),
        build_headers(opts),
        encode_body(body),
        build_options()
      )

    case response do
      {:ok, code, _headers, body} when code in 200..399 ->
        {:ok, decode_body(body)}

      {:ok, 422, _headers, body} ->
        {
          :error,
          body
          |> decode_body()
          |> resolve_error_response()
        }

      {:ok, code, _headers, _body} when code in 400..504 ->
        {:error, code_to_reason(code)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  for method <- ~w(get delete post put)a do
    @spec unquote(method)(binary) :: response
    @spec unquote(method)(binary, map | list) :: response
    @spec unquote(method)(binary, map, list) :: response
    def unquote(method)(path) do
      request(unquote(method), path, %{}, [])
    end

    def unquote(method)(path, payload) when is_map(payload) do
      request(unquote(method), path, payload, [])
    end

    def unquote(method)(path, opts) when is_list(opts) do
      request(unquote(method), path, %{}, opts)
    end

    def unquote(method)(path, payload, opts) do
      request(unquote(method), path, payload, opts)
    end
  end

  ## Helper Functions

  @spec build_url(binary, Keyword.t()) :: binary
  def build_url(path, opts) do
    environment = opts |> get_lazy_env(:environment) |> maybe_to_atom()
    merchant_id = get_lazy_env(opts, :merchant_id)

    endpoint
    |> URI.merge("#{merchant_id}/#{path}")
    |> to_string
  end

  defp maybe_to_atom(value) when is_binary(value), do: String.to_existing_atom(value)
  defp maybe_to_atom(value) when is_atom(value), do: value

  @doc false
  @spec encode_body(binary | map) :: binary
  def encode_body(body) when body == "" or body == %{}, do: ""
  def encode_body(body), do: Encoder.dump(body)

  @doc false
  @spec decode_body(binary) :: map
  def decode_body(body) do
    body
    |> :zlib.gunzip()
    |> String.trim()
    |> Decoder.load()
  rescue
    ErlangError -> Logger.error("unprocessable response")
  end

  @doc false
  @spec build_headers(Keyword.t()) :: [tuple]
  def build_headers(opts) do
    auth_header =
      case get_lazy_env(opts, :access_token, :none) do
        token when is_binary(token) ->
          "Bearer " <> token

        _ ->
          username = get_lazy_env(opts, :public_key)
          password = get_lazy_env(opts, :private_key)

          "Basic " <> :base64.encode("#{username}:#{password}")
      end

    [{"Authorization", auth_header} | @headers]
  end

  defp get_lazy_env(opts, key, default \\ nil) do
    Keyword.get_lazy(opts, key, fn -> Braintree.get_env(key, default) end)
  end

  @doc false
  @spec build_options() :: [...]
  def build_options do
    cacertfile = Path.join(:code.priv_dir(:braintree), @cacertfile)
    http_opts = Braintree.get_env(:http_options, [])

    [:with_body, ssl_options: [cacertfile: cacertfile]] ++ http_opts
  end

  @doc false
  @spec code_to_reason(integer) :: atom
  def code_to_reason(integer)

  for {code, status} <- @statuses do
    def code_to_reason(unquote(code)), do: unquote(status)
  end

  defp resolve_error_response(%{"api_error_response" => api_error_response}) do
    Error.new(api_error_response)
  end

  defp resolve_error_response(%{"unprocessable_entity" => _}) do
    Error.new(%{message: "Unprocessable Entity"})
  end
end
