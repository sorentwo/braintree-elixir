defmodule Braintree.HTTP do
  use HTTPoison.Base

  @endpoint "https://api.sandbox.braintreegateway.com/merchants/"

  @cacertfile Path.join(:code.priv_dir(:braintree), "/certs/api_braintreegateway_com.ca.crt")

  @headers [
    {"Accept", "application/xml"},
    {"User-Agent", "Braintree Elixir/0.1"},
    {"Accept-Encoding", "gzip"},
    {"X-ApiVersion", "4"},
    {"Content-Type", "application/xml"}
  ]

  def request(method, url, body, headers, options) do
    options = options ++ [hackney: [ssl_options: [cacertfile: @cacertfile]]]

    super(method, url, body, headers, options) |> process_response
  end

  ## HTTPoison Callbacks

  def process_url(path) do
    @endpoint <> path
  end

  def process_request_body(body) do
    body # convert to xml
  end

  def process_request_headers(_headers) do
    public  = Application.get_env(:braintree, :public_key)
    private = Application.get_env(:braintree, :private_key)

    [{"Authorization", basic_auth(public, private)} | @headers]
  end

  def process_response_body(body) do
    # unzip
    # convert from xml
    body
  end

  def process_response(resp), do: resp

  ## Helpers

  def basic_auth(user, pass) do
    "Basic " <> :base64.encode("#{user}:#{pass}")
  end
end
