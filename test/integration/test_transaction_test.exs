defmodule Braintree.Integration.TestTransactionTest do
  use ExUnit.Case, async: true

  alias Braintree.Transaction
  alias Braintree.Testing.Nonces
  alias Braintree.Testing.TestTransaction

  @moduletag :integration

  test "settle/1 succeeds if sale has been submitted for settlement" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment,
      options: %{submit_for_settlement: true}
    })

    {:ok, settle_transaction} = TestTransaction.settle(transaction.id)

    assert settle_transaction.status == "settled"
  end

  test "settle/1 fails if sale is authorized only" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment
    })

    {:error, error} = TestTransaction.settle(transaction.id)

    assert error.message == "Cannot transition transaction to settled, settlement_confirmed, or settlement_declined"
    refute error.params == %{}
    refute error.errors == %{}
  end

  test "settle/1 fails if transaction id is invalid" do
    {:error, error} = TestTransaction.settle("bogus")

    assert error.message == "Transaction ID is invalid."
  end

  test "settle_confirm/1 fails if sale is authorized only" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment
    })

    {:error, error} = TestTransaction.settlement_confirm(transaction.id)

    assert error.message == "Cannot transition transaction to settled, settlement_confirmed, or settlement_declined"
    refute error.params == %{}
    refute error.errors == %{}
  end

  test "settlement_confirm/1 fails if transaction id is invalid" do
    {:error, error} = TestTransaction.settlement_confirm("bogus")

    assert error.message == "Transaction ID is invalid."
  end

  test "settlement_confirm/1 succeeds if sale has been submit for settlement" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment,
      options: %{submit_for_settlement: true}
    })

    {:ok, settle_transaction} = TestTransaction.settlement_confirm(transaction.id)

    assert settle_transaction.status == "settlement_confirmed"
  end

  test "settlement_decline/1 fails if sale is authorized only" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment
    })

    {:error, error} = TestTransaction.settlement_decline(transaction.id)

    assert error.message == "Cannot transition transaction to settled, settlement_confirmed, or settlement_declined"
    refute error.params == %{}
    refute error.errors == %{}
  end

  test "settlement_decline/1 fails if transaction id is invalid" do
    {:error, error} = TestTransaction.settlement_decline("bogus")

    assert error.message == "Transaction ID is invalid."
  end
  
  test "settlement_decline/1 succeeds if sale has been submit for settlement" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: Nonces.paypal_one_time_payment,
      options: %{submit_for_settlement: true}
    })

    {:ok, settle_transaction} = TestTransaction.settlement_decline(transaction.id)

    assert settle_transaction.status == "settlement_declined"
  end
end
