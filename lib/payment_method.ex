defmodule Braintree.PaymentMethod do
  @moduledoc """
  Create, update, find and delete payment methods. Payment methods
  may be a `CreditCard` or a `PaypalAccount`.
  """

  alias Braintree.{CreditCard, HTTP, PaypalAccount}
  alias Braintree.ErrorResponse, as: Error

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

      credit_card.type # "Visa"
  """
  @spec create(Map.t) :: {:ok, CreditCard.t} | {:ok, PaypalAccount.t} | {:error, Error.t}
  def create(params \\ %{}) do
    case HTTP.post("payment_methods", %{payment_method: params}) do
      {:ok, %{"credit_card" => credit_card}} ->
        {:ok, CreditCard.construct(credit_card)}
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

      {:ok, payment_method} = Braintree.PaymentMethod.update(
        credit_card.token,
        %{cardholder_name: "NEW"}
      )

      payment_method.cardholder_name # "NEW"
  """
  @spec update(String.t, Map.t) :: {:ok, CreditCard.t} | {:ok, PaypalAccount.t} | {:error, Error.t}
  def update(token, params \\ %{}) do
    case HTTP.put("payment_methods/any/#{token}", %{payment_method: params}) do
      {:ok, %{"credit_card" => credit_card}} ->
        {:ok, CreditCard.construct(credit_card)}
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

      {:ok, "Success"} = Braintree.PaymentMethod.delete(token)
  """
  @spec delete(String.t) :: {:ok, binary} | {:error, Error.t}
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

      payment_method.type # CreditCard
  """
  @spec find(String.t) :: {:ok, CreditCard.t} | {:ok, PaypalAccount.t} | {:error, Error.t}
  def find(token) do
    case HTTP.get("payment_methods/any/#{token}") do
      {:ok, %{"credit_card" => credit_card}} ->
        {:ok, CreditCard.construct(credit_card)}
      {:ok, %{"paypal_account" => paypal_account}} ->
        {:ok, PaypalAccount.construct(paypal_account)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "Token is invalid."})}
    end
  end
end
