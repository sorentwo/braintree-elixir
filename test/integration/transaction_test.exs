defmodule Braintree.Integration.TransactionTest do
  use ExUnit.Case, async: true

  alias Braintree.Transaction

  @moduletag :integration

  @payment_method_nonce "fake-paypal-one-time-nonce"

  test "sale/1 successful with a payment nonce" do
    {:ok, transaction} = Transaction.sale(%{
      amount: "100.00",
      payment_method_nonce: @payment_method_nonce,
      options: %{submit_for_settlement: true}
    })

    assert transaction.amount == "100.00"
    assert transaction.status == "settling"
    assert transaction.id =~ ~r/^\w+$/
  end

  test "sale/1 failes with an invalid amount" do
    {:error, error} = Transaction.sale(%{
      amount: "2000.00",
      payment_method_nonce: @payment_method_nonce,
      options: %{submit_for_settlement: true}
    })

    assert error.message == "Do Not Honor"
    refute error.params == %{}
    refute error.errors == %{}
  end
end
