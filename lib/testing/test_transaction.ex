defmodule Braintree.Testing.TestTransaction do
  @moduledoc """
  Create transactions for testing purposes only.

  Transition to settled, settlement_confirmed, or settlement_declined states.
  """

  alias Braintree.ErrorResponse, as: Error
  alias Braintree.HTTP
  alias Braintree.Transaction

  @doc """
  Use a `transaction_id` to transition to settled status. This
  allows for testing of refunds.

  ## Example

  {:ok, transaction} = TestTransaction.settle(transaction_id: "123")

  transaction.status # "settled"
  """
  @spec settle(String.t()) :: {:ok, any} | {:error, Error.t()}
  def settle(transaction_id) do
    path = "transactions/#{transaction_id}/settle"

    with {:ok, payload} <- HTTP.put(path), do: response(payload)
  end

  @doc """
  Use a `transaction_id` to transition to settled_confirmed status

  ## Example

  {:ok, transaction} = TestTransaction.settlement_confirm(
  transaction_id: "123")

  transaction.status # "settlement_confirmed"
  """
  @spec settlement_confirm(String.t()) :: {:ok, any} | {:error, Error.t()}
  def settlement_confirm(transaction_id) do
    path = "transactions/#{transaction_id}/settlement_confirm"

    with {:ok, payload} <- HTTP.put(path), do: response(payload)
  end

  @doc """
  Use a `transaction_id` to transition to settlement_declined status

  ## Example

  {:ok, transaction} = TestTransaction.settlement_decline(
  transaction_id: "123")

  transaction.status # "settlement_declined"
  """
  @spec settlement_decline(String.t()) :: {:ok, any} | {:error, Error.t()}
  def settlement_decline(transaction_id) do
    path = "transactions/#{transaction_id}/settlement_decline"

    with {:ok, payload} <- HTTP.put(path), do: response(payload)
  end

  defp response(%{"transaction" => map}) do
    {:ok, Transaction.new(map)}
  end
end
