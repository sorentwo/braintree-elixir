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

    @doc """
    Build a new ConfigError exception.
    """
    @impl true
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

      iex> Braintree.get_env(:random_value, "random")
      "random"

      iex> Application.put_env(:braintree, :random_value, "not-random")
      ...> value = Braintree.get_env(:random_value)
      ...> Application.delete_env(:braintree, :random_value)
      ...> value
      "not-random"

      iex> System.put_env("RANDOM", "not-random")
      ...> Application.put_env(:braintree, :system_value, {:system, "RANDOM"})
      ...> value = Braintree.get_env(:system_value)
      ...> System.delete_env("RANDOM")
      ...> value
      "not-random"
  """
  @spec get_env(atom, any) :: any
  def get_env(key, default \\ nil) do
    case Application.fetch_env(:braintree, key) do
      {:ok, {:system, var}} when is_binary(var) ->
        fallback_or_raise(var, System.get_env(var), default)

      {:ok, value} ->
        value

      :error ->
        fallback_or_raise(key, nil, default)
    end
  end

  @doc """
  Convenience function for setting `braintree` application environment
  variables.

  ## Example

      iex> Braintree.put_env(:thingy, "thing")
      ...> Braintree.get_env(:thingy)
      "thing"
  """
  @spec put_env(atom, any) :: :ok
  def put_env(key, value) do
    Application.put_env(:braintree, key, value)
  end

  defp fallback_or_raise(key, nil, nil), do: raise(ConfigError, key)
  defp fallback_or_raise(_, nil, default), do: default
  defp fallback_or_raise(_, value, _), do: value
end
