defmodule Braintree.Integration.TransactionLineItemTest do
  use ExUnit.Case, async: true

  alias Braintree.Testing.Nonces
  alias Braintree.{Transaction, TransactionLineItem}

  @moduletag :integration
  test "find/1 returns a list of transaction line items" do
    [line_item, other_line_item] =
      line_items = [
        %{
          name: "Product Name",
          description: "Super profitable product",
          kind: "debit",
          quantity: "10",
          unit_amount: "9.5",
          unit_of_measure: "unit",
          total_amount: "95.00",
          tax_amount: "5.00",
          unit_tax_amount: "0.50",
          discount_amount: "1.00",
          product_code: "54321",
          commodity_code: "98765",
          url: "https://product.com"
        },
        %{
          name: "Other Product Name",
          description: "Other product that is still super profitable",
          kind: "debit",
          quantity: "10",
          unit_amount: "8.5",
          unit_of_measure: "unit",
          total_amount: "85.00",
          tax_amount: "4.00",
          unit_tax_amount: "0.40",
          discount_amount: "2.00",
          product_code: "54322",
          commodity_code: "98766",
          url: "https://otherproduct.com"
        }
      ]

    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable(),
        line_items: line_items
      })

    {:ok, [transaction_line_item, other_transaction_line_item]} =
      TransactionLineItem.find_all(transaction.id)

    line_item_keys = Map.keys(line_item)

    assert Map.take(transaction_line_item, line_item_keys) == Map.take(line_item, line_item_keys)

    assert Map.take(other_transaction_line_item, line_item_keys) ==
             Map.take(other_line_item, line_item_keys)
  end
end
