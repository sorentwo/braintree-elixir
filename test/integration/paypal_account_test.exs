defmodule Braintree.Integration.PaypalAccountTest do
  use ExUnit.Case, async: true

  alias Braintree.PaypalAccount
  alias Braintree.Customer
  alias Braintree.PaymentMethod
  alias Braintree.Testing.Nonces

  test "find/1 can successfully find a paypal account" do
    {:ok, customer} = Customer.create(%{
      first_name: "Test",
      last_name: "User"
    })

    {:ok, payment_method} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.paypal_future_payment
    })

    {:ok, paypal_account} = PaypalAccount.find(payment_method.token)

    assert paypal_account.email == "jane.doe@example.com"
    assert paypal_account.token =~ ~r/^\w+$/
  end

  test "find/1 fails with an invalid token" do
    {:error, error} = PaypalAccount.find("bogus")

    assert error.message == "Token is invalid."
  end

  test "update/2 can successfully update a paypal account" do
    {:ok, customer} = Customer.create(%{
      first_name: "Test",
      last_name: "User"
    })

    {:ok, payment_method} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.paypal_future_payment
    })

    {:ok, paypal_account} = PaypalAccount.update(payment_method.token, %{
      options: %{make_default: true}
    })

    assert paypal_account.default
  end

  test "update/2 fails with an invalid token" do
    {:error, error} = PaypalAccount.update("bogus", %{})

    assert error.message == "Token is invalid."
  end

  test "delete/1 can successfully delete a paypal account" do
    {:ok, customer} = Customer.create(%{
      first_name: "Test",
      last_name: "User"
    })

    {:ok, payment_method} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.paypal_future_payment
    })

    {:ok, message} = PaypalAccount.delete(payment_method.token)

    assert message == "Success"
  end

  test "delete/1 fails with an invalid token" do
    {:error, error} = PaypalAccount.delete("bogus")

    assert error.message == "Token is invalid."
  end
end
