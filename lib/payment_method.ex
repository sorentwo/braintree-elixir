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
    with {:ok, payload} <- HTTP.post("payment_methods", %{payment_method: params}) do
      {:ok, construct(payload)}
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
    path = "payment_methods/any/" <> token

    with {:ok, payload} <- HTTP.put(path, %{payment_method: params}) do
      {:ok, construct(payload)}
    end
  end


  @doc """
  Delete a payment method record, or return an error response if token invalid

  ## Example

      {:ok, "Success"} = Braintree.PaymentMethod.delete(token)
  """
  @spec delete(String.t) :: :ok | {:error, Error.t}
  def delete(token) do
    path = "payment_methods/any/" <> token

    with {:ok, _response} <- HTTP.delete(path) do
      :ok
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
    path = "payment_methods/any/" <> token

    with {:ok, payload} <- HTTP.get(path) do
      {:ok, construct(payload)}
    end
  end

  @spec construct(Map.t) :: CreditCard.t | PaypalAccount.t
  defp construct(%{"credit_card" => credit_card}) do
    CreditCard.construct(credit_card)
  end
  defp construct(%{"paypal_account" => paypal_account}) do
    PaypalAccount.construct(paypal_account)
  end
end
