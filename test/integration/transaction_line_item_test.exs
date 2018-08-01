defmodule Braintree.Integration.TransactionLineItemTest do
  use ExUnit.Case, async: true

  alias Braintree.{Transaction, TransactionLineItem}
  alias Braintree.Testing.Nonces

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
        },
      ]

    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable(),
        line_items: line_items
      })

    {:ok, [transaction_line_item, other_transaction_line_item]} =
      TransactionLineItem.find_all(transaction.id)

    assert transaction_line_item.name == line_item.name
    assert transaction_line_item.description == line_item.description
    assert transaction_line_item.kind == line_item.kind
    assert transaction_line_item.quantity == line_item.quantity
    assert transaction_line_item.unit_amount == line_item.unit_amount
    assert transaction_line_item.unit_of_measure == line_item.unit_of_measure
    assert transaction_line_item.total_amount == line_item.total_amount
    assert transaction_line_item.tax_amount == line_item.tax_amount
    assert transaction_line_item.unit_tax_amount == line_item.unit_tax_amount
    assert transaction_line_item.discount_amount == line_item.discount_amount
    assert transaction_line_item.product_code == line_item.product_code
    assert transaction_line_item.commodity_code == line_item.commodity_code
    assert transaction_line_item.url == line_item.url

    assert other_transaction_line_item.name == other_line_item.name
    assert other_transaction_line_item.description == other_line_item.description
    assert other_transaction_line_item.kind == other_line_item.kind
    assert other_transaction_line_item.quantity == other_line_item.quantity
    assert other_transaction_line_item.unit_amount == other_line_item.unit_amount
    assert other_transaction_line_item.unit_of_measure == other_line_item.unit_of_measure
    assert other_transaction_line_item.total_amount == other_line_item.total_amount
    assert other_transaction_line_item.tax_amount == other_line_item.tax_amount
    assert other_transaction_line_item.unit_tax_amount == other_line_item.unit_tax_amount
    assert other_transaction_line_item.discount_amount == other_line_item.discount_amount
    assert other_transaction_line_item.product_code == other_line_item.product_code
    assert other_transaction_line_item.commodity_code == other_line_item.commodity_code
    assert other_transaction_line_item.url == other_line_item.url
  end
end
