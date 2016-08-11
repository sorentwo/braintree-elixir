defmodule Braintree.ClientToken do
  @moduledoc """
  Generate a token required by the client SDK to communicate with Braintree.

  For additional reference see:
  https://developers.braintreepayments.com/reference/request/client-token/generate/ruby
  """

  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

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
  @spec generate(Map.t) :: {:ok, binary} | {:error, Error.t}
  def generate(params \\ %{}) when is_map(params) do
    params = with_version(params)

    case HTTP.post("client_token", %{client_token: params}) do
      {:ok, %{"client_token" => client_token}} ->
        {:ok, construct(client_token)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end

  defp construct(%{"value" => value}), do: value

  defp with_version(%{version: _} = params), do: params
  defp with_version(params), do: Map.put(params, :version, @version)
end
