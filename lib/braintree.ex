defmodule Braintree do
  @moduledoc """
  A native Braintree client library for Elixir. Only a subset of the API is
  supported and this is a work in progress. That said, it is already uned in
  production, and any modules that have been implemented can be used.

  For general reference please see:
  https://developers.braintreepayments.com/reference/overview
  """

  defmodule ConfigError do
    @moduledoc """
    Raised at runtime when a config variable is missing.
    """

    defexception [:message]

    def exception(value) do
      message = "missing config for :#{value}"

      %ConfigError{message: message}
    end
  end

  @doc """
  Convenience function for retrieving braintree specfic environment values, but
  will raise an exception if values are missing.

  ## Example

      iex> Braintree.get_env(:random_value)
      ** (Braintree.ConfigError) missing config for :random_value
  """
  @spec get_env(atom, any) :: any
  def get_env(key, default \\ nil) do
    case Application.fetch_env(:braintree, key) do
      {:ok, {:system, var}} when is_binary(var) ->
        System.get_env(var) || raise ConfigError, key
      {:ok, value} ->
        value
      :error ->
        raise ConfigError, key
    end
  end
end
