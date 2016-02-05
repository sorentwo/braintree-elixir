defmodule Braintree.HTTP do
  use HTTPoison.Base

  alias Braintree.XML
  alias HTTPoison.Response

  @endpoints [
    production: "https://api.braintreegateway.com/merchants/",
    sandbox: "https://api.sandbox.braintreegateway.com/merchants/"
  ]

  @cacertfile Path.join(:code.priv_dir(:braintree), "/certs/api_braintreegateway_com.ca.crt")

  @headers [
    {"Accept", "application/xml"},
    {"User-Agent", "Braintree Elixir/0.1"},
    {"Accept-Encoding", "gzip"},
    {"X-ApiVersion", "4"},
    {"Content-Type", "application/xml"}
  ]

  @options [
    hackney: [ssl_options: [cacertfile: @cacertfile]],
    connect_timeout: 10_000,
    recv_timeout: 10_000
  ]

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: [get: 3, post: 2, put: 2]
    end
  end

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
  @spec request(atom, binary, binary, headers, Keyword.t) ::
        {:ok, Response.t | AsyncResponse.t} | {:error, integer, Response.t} | {:error, Error.t}
  def request(method, url, body, headers \\ [], options \\ []) do
    super(method, url, body, headers, options ++ @options) |> process_response
  end

  ## HTTPoison Callbacks

  @doc false
  def process_url(path) do
    environment = Application.get_env(:braintree, :environment, :sandbox)
    merchant_id = Application.get_env(:braintree, :merchant_id)

    Keyword.fetch!(@endpoints, environment) <> merchant_id <> "/" <> path
  end

  @doc false
  def process_request_body(body) when body == "" or body == %{},
    do: ""
  def process_request_body(body),
    do: XML.dump(body)

  @doc false
  def process_request_headers(_headers) do
    public  = Application.get_env(:braintree, :public_key)
    private = Application.get_env(:braintree, :private_key)

    [{"Authorization", basic_auth(public, private)} | @headers]
  end

  @doc false
  def process_response_body(body) do
    body
    |> :zlib.gunzip
    |> XML.load
  rescue
    ErlangError -> IO.inspect(body)
  end

  @doc false
  def process_response({:ok, %Response{status_code: code, body: body}})
       when code >= 200 and code <= 399,
    do: {:ok, body}

  def process_response({:ok, %Response{body: body}}),
    do: {:error, body}

  def process_response({_code, %HTTPoison.Error{reason: reason}}),
    do: {:error, inspect(reason)}

  ## Helpers

  @doc false
  def basic_auth(user, pass) do
    "Basic " <> :base64.encode("#{user}:#{pass}")
  end
end
