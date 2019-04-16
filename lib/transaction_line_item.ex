defmodule Braintree.TransactionLineItem do
  @moduledoc """
  For fetching line items for a given transaction.

  https://developers.braintreepayments.com/reference/response/transaction-line-item/ruby
  """

  use Braintree.Construction

  alias Braintree.ErrorResponse, as: Error
  alias Braintree.HTTP

  @type t :: %__MODULE__{
          commodity_code: String.t(),
          description: String.t(),
          discount_amount: String.t(),
          kind: String.t(),
          name: String.t(),
          product_code: String.t(),
          quantity: String.t(),
          tax_amount: String.t(),
          total_amount: String.t(),
          unit_amount: String.t(),
          unit_of_measure: String.t(),
          unit_tax_amount: String.t(),
          url: String.t()
        }

  defstruct commodity_code: nil,
            description: nil,
            discount_amount: nil,
            kind: nil,
            name: nil,
            product_code: nil,
            quantity: nil,
            tax_amount: nil,
            total_amount: nil,
            unit_amount: nil,
            unit_of_measure: nil,
            unit_tax_amount: nil,
            url: nil

  @doc """
  Find transaction line items for the given transaction id.

  ## Example

      {:ok, transaction_line_items} = TransactionLineItem.find("123")
  """
  @spec find_all(String.t(), Keyword.t()) ::
          {:ok, [t]} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def find_all(transaction_id, opts \\ []) do
    path = "transactions/#{transaction_id}/line_items"

    with {:ok, payload} <- HTTP.get(path, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Converts a list of transaction line item maps into a list of transaction line items.

  ## Example

  transaction_line_items =
    Braintree.TransactionLineItem.new(%{
      "name" => "item name",
      "total_amount" => "100.00"
  })
  """
  @spec new(%{required(line_items :: String.t()) => [map]}) :: [t]
  def new(%{"line_items" => line_item_maps}) do
    Enum.map(line_item_maps, &super/1)
  end
end
