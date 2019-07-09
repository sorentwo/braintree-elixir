defmodule Braintree.VenmoAccount do
  @moduledoc """
  Find, update and delete Venmo Accounts using PaymentMethod token
  """

  use Braintree.Construction

  alias Braintree.ErrorResponse, as: Error
  alias Braintree.HTTP

  @type t :: %__MODULE__{
          created_at: String.t(),
          customer_id: String.t(),
          global_id: String.t(),
          image_url: String.t(),
          token: String.t(),
          source_description: String.t(),
          updated_at: String.t(),
          username: String.t(),
          venmo_user_id: String.t(),
          default: boolean,
          subscriptions: [any]
        }

  defstruct billing_agreement_id: nil,
            created_at: nil,
            customer_id: nil,
            global_id: nil,
            image_url: nil,
            token: nil,
            source_description: nil,
            updated_at: nil,
            username: nil,
            venmo_user_id: nil,
            default: false,
            subscriptions: []

  @doc """
  Find a venmo account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, venmo_account} = Braintree.Venmo.find(token)
  """
  @spec find(String.t(), Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def find(token, opts \\ []) do
    path = "payment_methods/venmo_account/" <> token

    with {:ok, %{"venmo_account" => map}} <- HTTP.get(path, opts) do
      {:ok, new(map)}
    end
  end

  @doc """
  Update a venmo account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, venmo_account} = Braintree.Venmo.update(
        token,
        %{options: %{make_default: true}
      )
  """
  @spec update(String.t(), map, Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def update(token, params, opts \\ []) do
    path = "payment_methods/venmo_account/" <> token

    with {:ok, %{"venmo_account" => map}} <- HTTP.put(path, %{venmo_account: params}, opts) do
      {:ok, new(map)}
    end
  end

  @doc """
  Delete a venmo account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, venmo_account} = Braintree.Venmo.delete(token)
  """
  @spec delete(String.t(), Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def delete(token, opts \\ []) do
    path = "payment_methods/venmo_account/" <> token

    with {:ok, _payload} <- HTTP.delete(path, opts) do
      :ok
    end
  end
end
