defmodule Braintree.HTTP do
  use HTTPoison.Base

  alias Braintree.XML
  alias HTTPoison.Response

  @endpoints [
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

  defmacro __using__(_opts) do
    quote do
      import Braintree.HTTP, only: [get: 3, post: 2, post: 4, put: 4]
    end
  end

  @spec request(atom, binary, binary, headers, Keyword.t) ::
        {:ok, Response.t | AsyncResponse.t} | {:error, Error.t}
  def request(method, url, body, headers, options) do
    options = options ++ [hackney: [ssl_options: [cacertfile: @cacertfile]]]

    super(method, url, body, headers, options) |> process_response
  end

  ## HTTPoison Callbacks

  @doc false
  def process_url(path) do
    environment = Application.get_env(:braintree, :environment, :sandbox)
    merchant_id = Application.get_env(:braintree, :merchant_id)

    Keyword.get(@endpoints, environment) <> merchant_id <> "/" <> path
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

  def process_response({_, %Response{status_code: code, body: body}}),
    do: {:error, code, body}

  def process_response({code, %HTTPoison.Error{reason: reason}}),
    do: {:error, code, inspect(reason)}

  ## Helpers

  @doc false
  def basic_auth(user, pass) do
    "Basic " <> :base64.encode("#{user}:#{pass}")
  end
end
