defmodule Braintree.PaypalAccount do
  @moduledoc """
  Find, update and delete Paypal Accounts using PaymentMethod token
  """

  use Braintree.Construction

  alias Braintree.ErrorResponse, as: Error
  alias Braintree.HTTP

  @type t :: %__MODULE__{
          billing_agreement_id: String.t(),
          created_at: String.t(),
          customer_id: String.t(),
          email: String.t(),
          image_url: String.t(),
          payer_info: String.t(),
          token: String.t(),
          updated_at: String.t(),
          default: boolean,
          is_channel_initated: boolean,
          subscriptions: [any]
        }

  defstruct billing_agreement_id: nil,
            created_at: nil,
            customer_id: nil,
            default: false,
            email: nil,
            image_url: nil,
            is_channel_initated: false,
            payer_info: nil,
            subscriptions: [],
            token: nil,
            updated_at: nil

  @doc """
  Find a paypal account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, paypal_account} = Braintree.PaypalAccount.find(token)
  """
  @spec find(String.t(), Keyword.t()) :: {:ok, t} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def find(token, opts \\ []) do
    path = "payment_methods/paypal_account/" <> token

    with {:ok, %{"paypal_account" => map}} <- HTTP.get(path, opts) do
      {:ok, new(map)}
    end
  end

  @doc """
  Update a paypal account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, paypal_account} = Braintree.PaypalAccount.update(
        token,
        %{options: %{make_default: true}
      )
  """
  @spec update(String.t(), map, Keyword.t()) :: {:ok, t} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def update(token, params, opts \\ []) do
    path = "payment_methods/paypal_account/" <> token

    with {:ok, %{"paypal_account" => map}} <- HTTP.put(path, %{paypal_account: params}, opts) do
      {:ok, new(map)}
    end
  end

  @doc """
  Delete a paypal account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, paypal_account} = Braintree.PaypalAccount.delete(token)
  """
  @spec delete(String.t(), Keyword.t()) :: {:ok, t} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def delete(token, opts \\ []) do
    path = "payment_methods/paypal_account/" <> token

    with {:ok, _payload} <- HTTP.delete(path, opts) do
      :ok
    end
  end
end
