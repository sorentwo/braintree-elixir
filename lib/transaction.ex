defmodule Braintree.Transaction do
  @moduledoc """
  Create a new sale.

  To create a transaction, you must include an amount and either a
  payment_method_nonce or a payment_method_token.

  https://developers.braintreepayments.com/reference/response/transaction/ruby
  """

  use Braintree.Construction

  alias Braintree.{AddOn, HTTP}
  alias Braintree.ErrorResponse, as: Error

  @type t :: %__MODULE__{
          add_ons: [AddOn.t()],
          additional_processor_response: String.t(),
          amount: number,
          apple_pay_details: String.t(),
          avs_error_response_code: String.t(),
          avs_postal_code_response_code: String.t(),
          avs_street_address_response_code: String.t(),
          billing: map,
          channel: String.t(),
          coinbase_details: String.t(),
          created_at: String.t(),
          credit_card: map,
          currency_iso_code: String.t(),
          custom_fields: map,
          customer_details: map,
          cvv_response_code: String.t(),
          descriptor: map,
          disbursement_details: map,
          discounts: [any],
          disputes: [any],
          escrow_status: String.t(),
          gateway_rejection_reason: String.t(),
          id: String.t(),
          merchant_account_id: String.t(),
          order_id: String.t(),
          payment_instrument_type: String.t(),
          paypal: map,
          plan_id: String.t(),
          processor_authorization_code: String.t(),
          processor_response_code: String.t(),
          processor_response_text: String.t(),
          processor_settlement_response_code: String.t(),
          processor_settlement_response_text: String.t(),
          purchase_order_number: String.t(),
          recurring: String.t(),
          refund_ids: String.t(),
          refunded_transaction_id: String.t(),
          risk_data: String.t(),
          service_fee_amount: number,
          settlement_batch_id: String.t(),
          shipping: map,
          status: String.t(),
          status_history: String.t(),
          subscription_details: map,
          subscription_id: String.t(),
          tax_amount: number,
          tax_exempt: boolean,
          type: String.t(),
          updated_at: String.t(),
          voice_referral_number: String.t()
        }

  defstruct add_ons: [],
            additional_processor_response: nil,
            amount: 0,
            apple_pay_details: nil,
            avs_error_response_code: nil,
            avs_postal_code_response_code: nil,
            avs_street_address_response_code: nil,
            billing: %{},
            channel: nil,
            coinbase_details: nil,
            created_at: nil,
            credit_card: %{},
            currency_iso_code: nil,
            custom_fields: %{},
            customer_details: %{},
            cvv_response_code: nil,
            descriptor: %{},
            disbursement_details: nil,
            discounts: [],
            disputes: [],
            escrow_status: nil,
            gateway_rejection_reason: nil,
            id: nil,
            merchant_account_id: nil,
            order_id: nil,
            payment_instrument_type: nil,
            paypal: %{},
            plan_id: nil,
            processor_authorization_code: nil,
            processor_response_code: nil,
            processor_response_text: nil,
            processor_settlement_response_code: nil,
            processor_settlement_response_text: nil,
            purchase_order_number: nil,
            recurring: nil,
            refund_ids: nil,
            refunded_transaction_id: nil,
            risk_data: nil,
            service_fee_amount: 0,
            settlement_batch_id: nil,
            shipping: %{},
            status: nil,
            status_history: nil,
            subscription_details: %{},
            subscription_id: nil,
            tax_amount: 0,
            tax_exempt: false,
            type: nil,
            updated_at: nil,
            voice_referral_number: nil

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
  @spec sale(map, Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def sale(params, opts \\ []) do
    sale_params = Map.merge(params, %{type: "sale"})

    with {:ok, payload} <- HTTP.post("transactions", %{transaction: sale_params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Use a `transaction_id` and optional `amount` to settle the transaction.
  Use this if `submit_for_settlement` was false while creating the charge using sale.

  ## Example

      {:ok, transaction} = Transaction.submit_for_settlement("123", %{amount: "100"})
      transaction.status # "settling"
  """
  @spec submit_for_settlement(String.t(), map, Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def submit_for_settlement(transaction_id, params, opts \\ []) do
    path = "transactions/#{transaction_id}/submit_for_settlement"

    with {:ok, payload} <- HTTP.put(path, %{transaction: params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Use a `transaction_id` and optional `amount` to issue a refund
  for that transaction

  ## Example

      {:ok, transaction} = Transaction.refund("123", %{amount: "100.00"})

      transaction.status # "refunded"
  """
  @spec refund(String.t(), map, Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def refund(transaction_id, params, opts \\ []) do
    path = "transactions/#{transaction_id}/refund"

    with {:ok, payload} <- HTTP.post(path, %{transaction: params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Use a `transaction_id` to issue a void for that transaction

  ## Example

      {:ok, transaction} = Transaction.void("123")

      transaction.status # "voided"
  """
  @spec void(String.t(), Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def void(transaction_id, opts \\ []) do
    path = "transactions/#{transaction_id}/void"

    with {:ok, payload} <- HTTP.put(path, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Find an existing transaction by `transaction_id`

  ## Example

      {:ok, transaction} = Transaction.find("123")
  """
  @spec find(String.t(), Keyword.t()) :: {:ok, t} | {:error, Error.t()}
  def find(transaction_id, opts \\ []) do
    path = "transactions/#{transaction_id}"

    with {:ok, payload} <- HTTP.get(path, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Convert a map into a Transaction struct.

  Add_ons are converted to a list of structs as well.

  ## Example

  transaction =
    Braintree.Transaction.new(%{
      "subscription_id" => "subxid",
      "status" => "submitted_for_settlement"
    })
  """
  def new(%{"transaction" => map}) do
    new(map)
  end

  def new(map) when is_map(map) do
    transaction = super(map)

    %{transaction | add_ons: AddOn.new(transaction.add_ons)}
  end

  def new(list) when is_list(list) do
    Enum.map(list, &new/1)
  end
end
