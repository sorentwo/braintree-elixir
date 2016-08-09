defmodule Braintree.TransactionTest do
  use ExUnit.Case, async: true

  alias Braintree.Transaction

  test "paypal transaction attributes are included as a map" do
    transaction = %Transaction{
      paypal: %{
        payer_email: "nick@example.com"
      }
    }

    refute transaction.id
    assert transaction.paypal.payer_email == "nick@example.com"
  end
end
