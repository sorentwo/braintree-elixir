defmodule Braintree.PaypalAccount do
  @moduledoc """
  Find, update and delete Paypal Accounts using PaymentMethod token
  """
  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error
  import Braintree.Util, only: [atomize: 1]

  @type t :: %__MODULE__{
               billing_agreement_id: String.t,
               created_at:           String.t,
               customer_id:          String.t,
               email:                String.t,
               image_url:            String.t,
               payer_info:           String.t,
               token:                String.t,
               updated_at:           String.t,
               default:              boolean,
               is_channel_initated:  boolean,
               subscriptions:        []
             }

  defstruct billing_agreement_id: nil,
            created_at:           nil,
            customer_id:          nil,
            email:                nil,
            image_url:            nil,
            payer_info:           nil,
            token:                nil,
            updated_at:           nil,
            default:              false,
            is_channel_initated:  false,
            subscriptions:        []
  @doc """
  Find a paypal account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, paypal_account} = Braintree.PaypalAccount.find(token)
  """
  @spec find(String.t) :: {:ok, t} | {:error, Error.t}
  def find(token) do
    case HTTP.get("payment_methods/paypal_account/#{token}") do
      {:ok, %{"paypal_account" => paypal_account}} ->
        {:ok, construct(paypal_account)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "Token is invalid."})}
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
  @spec update(String.t, Map.t) :: {:ok, t} | {:error, Error.t}
  def update(token, params) do
    case HTTP.put("payment_methods/paypal_account/#{token}", %{paypal_account: params}) do
      {:ok, %{"paypal_account" => paypal_account}} ->
        {:ok, construct(paypal_account)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "Token is invalid."})}
    end
  end

  @doc """
  Delete a paypal account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, paypal_account} = Braintree.PaypalAccount.delete(token)
  """
  @spec delete(String.t) :: {:ok, t} | {:error, Error.t}
  def delete(token) do
    case HTTP.delete("payment_methods/paypal_account/#{token}") do
      {:ok, %{}} ->
        {:ok, "Success"}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "Token is invalid."})}
    end
  end

  def construct(map) do
    struct(__MODULE__, atomize(map))
  end
end
