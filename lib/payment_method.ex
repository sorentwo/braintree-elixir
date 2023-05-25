defmodule Braintree.PaymentMethod do
  @moduledoc """
  Create, update, find and delete payment methods. Payment methods
  may be a `CreditCard` or a `PaypalAccount`.
  """

  alias Braintree.{AndroidPayCard, ApplePayCard, CreditCard, HTTP, PaypalAccount, UsBankAccount, VenmoAccount}
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
  @spec create(map, Keyword.t()) ::
          {:ok, CreditCard.t()}
          | {:ok, PaypalAccount.t()}
          | {:ok, UsBankAccount.t()}
          | {:ok, VenmoAccount.t()}
          | {:error, Error.t()}
  def create(params \\ %{}, opts \\ []) do
    with {:ok, payload} <- HTTP.post("payment_methods", %{payment_method: params}, opts) do
      {:ok, new(payload)}
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
  @spec update(String.t(), map, Keyword.t()) ::
          {:ok, CreditCard.t()} | {:ok, PaypalAccount.t()} | {:error, Error.t()}
  def update(token, params \\ %{}, opts \\ []) do
    path = "payment_methods/any/" <> token

    with {:ok, payload} <- HTTP.put(path, %{payment_method: params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Delete a payment method record, or return an error response if token invalid

  ## Example

      {:ok, "Success"} = Braintree.PaymentMethod.delete(token)
  """
  @spec delete(String.t(), Keyword.t()) :: :ok | {:error, Error.t()}
  def delete(token, opts \\ []) do
    path = "payment_methods/any/" <> token

    with {:ok, _response} <- HTTP.delete(path, opts) do
      :ok
    end
  end

  @doc """
  Find a payment method record, or return an error response if token invalid

  ## Example

      {:ok, payment_method} = Braintree.PaymentMethod.find(token)

      payment_method.type # CreditCard
  """
  @spec find(String.t(), Keyword.t()) ::
          {:ok, CreditCard.t()}
          | {:ok, PaypalAccount.t()}
          | {:ok, UsBankAccount.t()}
          | {:error, Error.t()}
  def find(token, opts \\ []) do
    path = "payment_methods/any/" <> token

    with {:ok, payload} <- HTTP.get(path, opts) do
      {:ok, new(payload)}
    end
  end

  @spec new(map) ::
          AndroidPayCard.t()
          | ApplePayCard.t()
          | CreditCard.t()
          | PaypalAccount.t()
          | UsBankAccount.t()
  defp new(%{"android_pay_card" => android_pay_card}) do
    AndroidPayCard.new(android_pay_card)
  end

  defp new(%{"apple_pay_card" => apple_pay_card}) do
    ApplePayCard.new(apple_pay_card)
  end

  defp new(%{"credit_card" => credit_card}) do
    CreditCard.new(credit_card)
  end

  defp new(%{"paypal_account" => paypal_account}) do
    PaypalAccount.new(paypal_account)
  end

  defp new(%{"us_bank_account" => us_bank_account}) do
    UsBankAccount.new(us_bank_account)
  end

  defp new(%{"venmo_account" => venmo_account}) do
    VenmoAccount.new(venmo_account)
  end
end
