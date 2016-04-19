defmodule Braintree.Integration.TransactionTest do
  use ExUnit.Case, async: true

  alias Braintree.Transaction
  alias Braintree.Testing.Nonces
  alias Braintree.Testing.TestTransaction

  @moduletag :integration

  test "sale/1 successful with a payment nonce" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment,
      options: %{submit_for_settlement: true}
    })

    assert transaction.amount == "100.00"
    assert transaction.status == "settling"
    assert transaction.id =~ ~r/^\w+$/
  end

  test "sale/1 status is authorized when not submit for settlement" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment
    })

    assert transaction.amount == "100.00"
    assert transaction.status == "authorized"
    assert transaction.id =~ ~r/^\w+$/
  end

  test "sale/1 fails with an invalid amount" do
    {:error, error} = Transaction.sale(%{
      amount: "2000.00",
      payment_method_nonce: Nonces.paypal_one_time_payment,
      options: %{submit_for_settlement: true}
    })

    assert error.message == "Do Not Honor"
    refute error.params == %{}
    refute error.errors == %{}
  end

  test "refund/2 fails if sale is not yet settled" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment
    })

    {:error, error}  = Transaction.refund(transaction.id, %{amount: "100.00"})
    
    assert error.message == "Cannot refund a transaction unless it is settled."
    refute error.params == %{}
    refute error.errors == %{}
  end

  test "refund/2 succeeds if sale is has been settled" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment,
      options: %{submit_for_settlement: true}
    })

    {:ok, _} = TestTransaction.settle(transaction.id)
    {:ok, refund} = Transaction.refund(transaction.id, %{amount: "100.00"})

    assert refund.refunded_transaction_id =~ ~r/^\w+$/
    assert refund.amount == "100.00"
  end

  test "void/1 succeeds for previous sale transaction" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment
    })

    {:ok, void}  = Transaction.void(transaction.id)

    assert void.status == "voided"
  end

  test "void/1 fails for invalid transaction id" do
    {:error, error}  = Transaction.void("bogus")

    assert error.message == "Transaction ID is invalid."
  end

  test "find/1 fails for invalid transaction id" do
    {:error, error}  = Transaction.find("bogus")

    assert error.message == "Transaction ID is invalid."
  end

  test "find/1 suceeds for existing transaction" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment
    })

    {:ok, found_transaction}  = Transaction.find(transaction.id)

    assert found_transaction.status == transaction.status
    assert found_transaction.amount == transaction.amount
  end
end
