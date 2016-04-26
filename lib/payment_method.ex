defmodule Braintree.PaymentMethod do
  @moduledoc """
  Create, update, find and delete payment methods
  """
  @type t :: %__MODULE__{
               bin:                      String.t,
               card_type:                String.t,
               cardholder_name:          String.t,
               commercial:               String.t,
               country_of_issuance:      String.t,
               customer_id:              String.t,
               customer_location:        String.t,
               debit:                    String.t,
               default:                  String.t,
               durbin_regulated:         String.t,
               expiration_month:         String.t,
               expiration_year:          String.t,
               expired:                  String.t,
               healthcare:               String.t,
               image_url:                String.t,
               issuing_bank:             String.t,
               last_4:                   String.t,
               payroll:                  String.t,
               prepaid:                  String.t,
               token:                    String.t,
               unique_number_identifier: String.t,
               created_at:               String.t,
               updated_at:               String.t,
               venmo_sdk:                boolean,
               subscriptions:            [],
               verifications:            []
             }

  defstruct bin:                      nil,
            card_type:                nil,
            cardholder_name:          nil,
            commercial:               "Unknown",
            country_of_issuance:      "Unknown",
            customer_id:              nil,
            customer_location:        nil,
            debit:                    "Unknown",
            default:                  false,
            durbin_regulated:         "Unknown",
            expiration_month:         nil,
            expiration_year:          nil,
            expired:                  nil,
            healthcare:               "Unknown",
            image_url:                nil,
            issuing_bank:             "Unknown",
            last_4:                   nil,
            payroll:                  "Unknown",
            prepaid:                  "Unknown",
            token:                    nil,
            unique_number_identifier: nil,
            created_at:               nil,
            updated_at:               nil,
            venmo_sdk:                "Unknown",
            subscriptions:            [],
            verifications:            []

  alias Braintree.HTTP
  alias Braintree.PaypalAccount
  alias Braintree.ErrorResponse, as: Error
  import Braintree.Util, only: [atomize: 1]

  @doc """
  Create a payment method record, or return an error response with after failed
  validation.

  ## Example

      {:ok, customer} = Braintree.Customer.create(%{
        first_name: "Jen",
        last_name: "Smith"
      })

      {:ok, credit_card} = Braintree.PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Braintree.Testing.Nonces.transactable
      })

      credit_card.type #Visa
  """
  @spec create(Map.t) :: {:ok, t} | {:error, Error.t}
  def create(params \\ %{}) do
    case HTTP.post("payment_methods", %{payment_method: params}) do
      {:ok, %{"credit_card" => credit_card}} ->
        {:ok, construct(credit_card)}
      {:ok, %{"paypal_account" => paypal_account}} ->
        {:ok, PaypalAccount.construct(paypal_account)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end

  @doc """
  Update a payment method record, or return an error response with after failed
  validation.

  ## Example

      {:ok, customer} = Braintree.Customer.create(%{
        first_name: "Jen",
        last_name: "Smith"
      })

      {:ok, credit_card} = Braintree.PaymentMethod.create(%{
        customer_id: customer.id,
        cardholder_name: "CH Name",
        payment_method_nonce: Braintree.Testing.Nonces.transactable
      })

      {:ok, payment_method} = Braintree.PaymentMethod.update(credit_card.token,
        %{
          cardholder_name: "NEW"
        }
      )

      payment_method.cardholder_name #NEW
  """
  @spec update(String.t, Map.t) :: {:ok, t} | {:error, Error.t}
  def update(token, params \\ %{}) do
    case HTTP.put("payment_methods/any/#{token}", %{payment_method: params}) do
      {:ok, %{"credit_card" => credit_card}} ->
        {:ok, construct(credit_card)}
      {:ok, %{"paypal_account" => paypal_account}} ->
        {:ok, PaypalAccount.construct(paypal_account)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "Token is invalid."})}
    end
  end


  @doc """
  Delete a payment method record, or return an error response if token invalid

  ## Example

      {:ok, message} = Braintree.PaymentMethod.delete(token)
      message #Success
  """
  @spec delete(String.t) :: {:ok, t} | {:error, Error.t}
  def delete(token) do
    case HTTP.delete("payment_methods/any/#{token}") do
      {:ok, %{}} ->
        {:ok, "Success"}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "Token is invalid."})}
    end
  end

  @doc """
  Find a payment method record, or return an error response if token invalid

  ## Example

      {:ok, payment_method} = Braintree.PaymentMethod.find(token)
      payment_method.type #CreditCard
  """
  @spec find(String.t) :: {:ok, t} | {:error, Error.t}
  def find(token) do
    case HTTP.get("payment_methods/any/#{token}") do
      {:ok, %{"credit_card" => credit_card}} ->
        {:ok, construct(credit_card)}
      {:ok, %{"paypal_account" => paypal_account}} ->
        {:ok, PaypalAccount.construct(paypal_account)}
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
