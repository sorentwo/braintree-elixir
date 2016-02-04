defmodule Braintree.Integration.TransactionTest do
  use ExUnit.Case, async: true

  alias Braintree.Transaction
  alias Braintree.Testing.Nonces

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

  test "sale/1 failes with an invalid amount" do
    {:error, error} = Transaction.sale(%{
      amount: "2000.00",
      payment_method_nonce: Nonces.paypal_one_time_payment,
      options: %{submit_for_settlement: true}
    })

    assert error.message == "Do Not Honor"
    refute error.params == %{}
    refute error.errors == %{}
  end
end
