defmodule Braintree.Transaction do
  @moduledoc """
  Create a new sale.

  To create a transaction, you must include an amount and either a
  payment_method_nonce or a payment_method_token.
  """

  import Braintree.Util, only: [atomize: 1]

  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

  defstruct add_ons:                            nil,
            additional_processor_response:      nil,
            amount:                             nil,
            apple_pay_details:                  nil,
            avs_error_response_code:            nil,
            avs_postal_code_response_code:      nil,
            avs_street_address_response_code:   nil,
            billing_details:                    nil,
            channel:                            nil,
            coinbase_details:                   nil,
            created_at:                         nil,
            credit_card_details:                nil,
            currency_iso_code:                  nil,
            custom_fields:                      nil,
            customer_details:                   nil,
            cvv_response_code:                  nil,
            descriptor:                         nil,
            discounts:                          nil,
            disbursement_details:               nil,
            disputes:                           nil,
            escrow_status:                      nil,
            gateway_rejection_reason:           nil,
            id:                                 nil,
            merchant_account_id:                nil,
            order_id:                           nil,
            payment_instrument_type:            nil,
            paypal_details:                     nil,
            plan_id:                            nil,
            processor_authorization_code:       nil,
            processor_response_code:            nil,
            processor_response_text:            nil,
            processor_settlement_response_code: nil,
            processor_settlement_response_text: nil,
            purchase_order_number:              nil,
            recurring:                          nil,
            refund_ids:                         nil,
            refunded_transaction_id:            nil,
            risk_data:                          nil,
            service_fee_amount:                 nil,
            settlement_batch_id:                nil,
            shipping_details:                   nil,
            status:                             nil,
            status_history:                     nil,
            subscription_details:               nil,
            subscription_id:                    nil,
            tax_amount:                         nil,
            tax_exempt:                         nil,
            type:                               nil,
            updated_at:                         nil,
            voice_referral_number:              nil

  @doc """
  Use a `payment_method_nonce` or `payment_method_token` to make a one time
  charge against a payment method.

  ## Example

      {:ok, transaction} = Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: @payment_method_nonce,
        options: %{submit_for_settlement: true}
      })

      transaction.status # "settling"
  """
  @spec sale(Map.t) :: {:ok, any} | {:error, Error.t}
  def sale(params) do
    sale_params = Map.merge(params, %{type: "sale"})

    case HTTP.post("transactions", %{transaction: sale_params}) do
      {:ok, %{"transaction" => transaction}} ->
        {:ok, construct(transaction)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end


  @doc """
  Use a `transaction_id` and optional `amount` to issue a refund
  for that transaction

  ## Example

      {:ok, transaction} = Transaction.refund(
      "123",
      %{
        amount: "100.00"
      })

      transaction.status # "refunded"
  """
  @spec refund(String.t, Map.t) :: {:ok, any} | {:error, Error.t}
  def refund(transaction_id, params) do
    case HTTP.post("transactions/#{transaction_id}/refund", %{transaction: params}) do
      {:ok, %{"transaction" => transaction}} ->
        {:ok, construct(transaction)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end

  @doc """
  Use a `transaction_id` to issue a void for that transaction

  ## Example

      {:ok, transaction} = Transaction.void("123")

      transaction.status # "voided"
  """
  @spec void(String.t) :: {:ok, any} | {:error, Error.t}
  def void(transaction_id) do
    case HTTP.put("transactions/#{transaction_id}/void", %{}) do
      {:ok, %{"transaction" => transaction}} ->
        {:ok, construct(transaction)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "Transaction ID is invalid."})}
    end
  end

  @doc """
  Find an existing transaction by `transaction_id`

  ## Example

      {:ok, transaction} = Transaction.find("123")
  """
  @spec find(String.t) :: {:ok, any} | {:error, Error.t}
  def find(transaction_id) do
    case HTTP.get("transactions/#{transaction_id}") do
      {:ok, %{"transaction" => transaction}} ->
        {:ok, construct(transaction)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "Transaction ID is invalid."})}
    end
  end

  def construct(map) do
    struct(__MODULE__, atomize(map))
  end
end
