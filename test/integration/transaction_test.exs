defmodule Braintree.Integration.TransactionTest do
  use ExUnit.Case, async: true

  alias Braintree.Transaction
  alias Braintree.Testing.{CreditCardNumbers, Nonces, TestTransaction}

  @moduletag :integration

  test "sale/1 successful with a payment nonce" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable(),
        options: %{submit_for_settlement: true}
      })

    assert transaction.amount == "100.00"
    assert transaction.status == "submitted_for_settlement"
    assert transaction.id =~ ~r/^\w+$/
    assert transaction.customer.id == nil
  end

  test "sale/1 submits billing information" do
    [card_number | _] = CreditCardNumbers.master_cards()

    {:ok, transaction} =
      Transaction.sale(%{
        amount: "112.44",
        customer: %{
          last_name: "Adama"
        },
        credit_card: %{
          number: card_number,
          expiration_date: "05/2020"
        },
        billing: %{
          country_name: "Botswana",
          country_code_alpha2: "BW",
          country_code_alpha3: "BWA",
          country_code_numeric: "072"
        },
        shipping: %{
          country_name: "Bhutan",
          country_code_alpha2: "BT",
          country_code_alpha3: "BTN",
          country_code_numeric: "064"
        }
      })

    assert transaction.billing.country_name == "Botswana"
    assert transaction.billing.country_code_alpha2 == "BW"
    assert transaction.billing.country_code_numeric == "072"

    assert transaction.shipping.country_name == "Bhutan"
    assert transaction.shipping.country_code_alpha2 == "BT"
    assert transaction.shipping.country_code_numeric == "064"
  end

  test "sale/1 with :store_in_vault_on_success" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable(),
        options: %{
          store_in_vault_on_success: true,
          submit_for_settlement: true
        }
      })

    assert transaction.amount == "100.00"
    assert transaction.status == "submitted_for_settlement"
    assert transaction.id =~ ~r/^\w+$/
    assert transaction.customer.id =~ ~r/^\w+$/
  end

  test "sale/1 status is authorized when not submit for settlement" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable()
      })

    assert transaction.amount == "100.00"
    assert transaction.status == "authorized"
    assert transaction.id =~ ~r/^\w+$/
  end

  test "sale/1 with ApplePay" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.apple_pay_visa(),
        options: %{submit_for_settlement: true}
      })

    assert transaction.amount == "100.00"
    assert transaction.payment_instrument_type == "apple_pay_card"
    assert transaction.status == "submitted_for_settlement"
    assert transaction.id =~ ~r/^\w+$/

    assert transaction.apple_pay.card_type == "Apple Pay - Visa"
    assert transaction.apple_pay.cardholder_name == "Visa Apple Pay Cardholder"

    assert transaction.apple_pay.image_url ==
             "https://assets.braintreegateway.com/payment_method_logo/apple_pay.png?environment=sandbox"

    assert transaction.apple_pay.last_4 == "1881"
  end

  test "sale/1 with Google Pay/Android Pay" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.android_pay_visa_nonce(),
        options: %{submit_for_settlement: true}
      })

    assert transaction.amount == "100.00"
    assert transaction.payment_instrument_type == "android_pay_card"
    assert transaction.status == "submitted_for_settlement"
    assert transaction.id =~ ~r/^\w+$/

    assert transaction.android_pay_card.image_url ==
             "https://assets.braintreegateway.com/payment_method_logo/android_pay_card.png?environment=sandbox"

    assert transaction.android_pay_card.source_card_last_4 == "1111"
    assert transaction.android_pay_card.source_card_type == "Visa"
    assert transaction.android_pay_card.virtual_card_last_4 == "1881"
    assert transaction.android_pay_card.virtual_card_type == "Visa"
  end

  test "submit_for_settlement/2 can be used if transaction is authorized but not settling" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable()
      })

    {:ok, settled_transaction} = Transaction.submit_for_settlement(transaction.id, %{})

    assert settled_transaction.status == "submitted_for_settlement"
  end

  test "submit_for_settlement/2 fails if transaction is already settling" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable(),
        options: %{submit_for_settlement: true}
      })

    {:error, error} = Transaction.submit_for_settlement(transaction.id, %{})

    assert error.message =~ "Cannot submit for settlement unless status is authorized."
  end

  test "submit_for_settlement/2 by default will settle the amount charged" do
    amount_charged = "100.00"

    {:ok, transaction} =
      Transaction.sale(%{
        amount: amount_charged,
        payment_method_nonce: Nonces.transactable()
      })

    {:ok, settled_transaction} = Transaction.submit_for_settlement(transaction.id, %{})

    assert settled_transaction.amount == amount_charged
  end

  test "submit_for_settlement/2 can be used for partial settlement" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable()
      })

    {:ok, settled_transaction} =
      Transaction.submit_for_settlement(transaction.id, %{amount: "55.00"})

    refute transaction.amount == settled_transaction.amount
    assert transaction.amount == "100.00"
    assert settled_transaction.amount == "55.00"
  end

  test "sale/1 fails with an invalid amount" do
    {:error, error} =
      Transaction.sale(%{
        amount: "2000.00",
        payment_method_nonce: Nonces.transactable(),
        options: %{submit_for_settlement: true}
      })

    assert error.message == "Do Not Honor"
    refute error.params == %{}
    refute error.errors == %{}
  end

  test "refund/2 fails if sale is not yet settled" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable()
      })

    {:error, error} = Transaction.refund(transaction.id, %{amount: "100.00"})

    assert error.message =~ "Cannot refund transaction unless it is settled"
    refute error.params == %{}
    refute error.errors == %{}
  end

  test "refund/2 succeeds if sale is has been settled" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable(),
        options: %{submit_for_settlement: true}
      })

    {:ok, _} = TestTransaction.settle(transaction.id)
    {:ok, refund} = Transaction.refund(transaction.id, %{amount: "100.00"})

    assert refund.refunded_transaction_id =~ ~r/^\w+$/
    assert refund.amount == "100.00"
  end

  test "void/1 succeeds for previous sale transaction" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable()
      })

    {:ok, void} = Transaction.void(transaction.id)

    assert void.status == "voided"
  end

  test "find/1 fails for invalid transaction id" do
    assert {:error, :not_found} = Transaction.find("bogus")
  end

  test "find/1 suceeds for existing transaction" do
    {:ok, transaction} =
      Transaction.sale(%{
        amount: "100.00",
        payment_method_nonce: Nonces.transactable()
      })

    {:ok, found_transaction} = Transaction.find(transaction.id)

    assert found_transaction.status == transaction.status
    assert found_transaction.amount == transaction.amount
  end
end
