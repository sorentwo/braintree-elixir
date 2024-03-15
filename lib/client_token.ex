defmodule Braintree.ClientToken do
  @moduledoc """
  Generate a token required by the client SDK to communicate with Braintree.

  For additional reference see:
  https://developers.braintreepayments.com/reference/request/client-token/generate/ruby
  """

  alias Braintree.HTTP

  @version 2

  @doc """
  Create a client token, or return an error response.

  ## Options

  * `:version` - The default value is 2. Current supported versions are 1, 2,
    and 3. Please check your client-side SDKs in use before changing this
    value.

  ## Example

      {:ok, token} = Braintree.ClientToken.generate()

  Generate a specific token version:

      {:ok, token} = Braintree.ClientToken.generate(%{version: 3})
  """
  @spec generate(map, Keyword.t()) :: {:ok, binary} | HTTP.error()
  def generate(params \\ %{}, opts \\ []) when is_map(params) do
    params = %{client_token: with_version(params)}

    with {:ok, payload} <- HTTP.post("client_token", params, opts) do
      %{"client_token" => %{"value" => value}} = payload

      {:ok, value}
    end
  end

  defp with_version(%{version: _} = params), do: params
  defp with_version(params), do: Map.put(params, :version, @version)
end
