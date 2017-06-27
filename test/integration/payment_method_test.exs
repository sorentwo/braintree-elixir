defmodule Braintree.Integration.PaymentMethodTest do
  use ExUnit.Case, async: true

  alias Braintree.Customer
  alias Braintree.PaymentMethod
  alias Braintree.PaymentMethodNonce
  alias Braintree.Testing.Nonces
  alias Braintree.Testing.CreditCardNumbers

  @moduletag :integration

  test "create/1 fails when customer_id not provided" do
    {:error, error} = PaymentMethod.create(%{
      payment_method_nonce: Nonces.transactable
    })

    assert error.message == "Customer ID is required."
  end

  test "create/1 fails when payment_method_nonce not provided" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })

    {:error, error} = PaymentMethod.create(%{
      customer_id: customer.id
    })

    assert error.message == "Nonce is required."
  end

  test "create/1 can create a payment method from an existing customer and fake nonce" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })

    {:ok, payment_method} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.transactable
    })

    assert payment_method.card_type == "Visa"
    assert payment_method.bin =~ ~r/^\w+$/
  end

  test "create/1 can create a payment method from a vaulted credit card nonce" do
    {:ok, customer} = Customer.create(
      first_name: "Rick",
      last_name: "Grimes",
      credit_card: %{
        number: master_card,
        expiration_date: "01/2016",
        cvv: "100"
      }
    )

    [card] = customer.credit_cards
    {:ok, payment_method_nonce} = PaymentMethodNonce.create(card.token)

    {:ok, payment_method} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: payment_method_nonce.nonce
    })

    assert payment_method.card_type == "MasterCard"
    assert payment_method.bin =~ card.bin
  end

  test "create/1 can create a paypal payment method" do
    {:ok, customer} = Customer.create(%{
      first_name: "Rick",
      last_name: "Grimes"
    })

    {:ok, paypal_account} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.paypal_future_payment
    })

    assert paypal_account.email == "jane.doe@example.com"
    assert paypal_account.token =~ ~r/^\w+$/
  end

  test "create/1 can successfully make paypal payment method the default" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })

    {:ok, paypal_account} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.paypal_future_payment,
      options: %{make_default: true}
    })

    assert paypal_account.default == true
  end

  test "update/1 fails when invalid token provided" do
    {:error, error} = PaymentMethod.update("bogus")

    assert error.message == "payment token is invalid"
  end

  test "update/2 can successfully update existing payment_method" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })

    {:ok, payment_method} = PaymentMethod.create(%{
      customer_id: customer.id,
      cardholder_name: "Bruce",
      payment_method_nonce: Nonces.transactable
    })

    assert payment_method.cardholder_name == "Bruce"

    {:ok, updated_method} = PaymentMethod.update(payment_method.token, %{
      cardholder_name: "Steve"
    })

    assert updated_method.cardholder_name == "Steve"
  end

  test "update/2 can successfully call update on a paypal payment method" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })

    {:ok, paypal_account} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.paypal_future_payment
    })

    {:ok, updated_paypal_account} = PaymentMethod.update(paypal_account.token, %{})

    assert updated_paypal_account.email == "jane.doe@example.com"
  end

  test "delete/1 fails when invalid token provided" do
    {:error, error} = PaymentMethod.delete("bogus")

    assert error.message == "payment token is invalid"
  end

  test "delete/1 succeeds when valid token provided" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })

    {:ok, payment_method} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.transactable
    })

    {:ok, message} = PaymentMethod.delete(payment_method.token)

    assert message == "Success"
  end

  test "delete/1 can delete paypal payment method" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })

    {:ok, paypal_account} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.paypal_future_payment
    })

    {:ok, message} = PaymentMethod.delete(paypal_account.token)

    assert message == "Success"
  end

  test "find/1 fails when invalid token provided" do
    {:error, error} = PaymentMethod.find("bogus")

    assert error.message == "payment token is invalid"
  end

  test "find/1 succeeds when valid token provided" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })

    {:ok, payment_method} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.transactable
    })

    {:ok, found_payment} = PaymentMethod.find(payment_method.token)

    assert found_payment.cardholder_name == payment_method.cardholder_name
    assert found_payment.card_type == payment_method.card_type
    assert found_payment.token == payment_method.token
  end

  test "find/1 can find an existing paypal payment method" do
    {:ok, customer} = Customer.create(%{
      first_name: "Bill",
      last_name: "Gates"
    })

    {:ok, paypal_account} = PaymentMethod.create(%{
      customer_id: customer.id,
      payment_method_nonce: Nonces.paypal_future_payment
    })

    {:ok, found_paypal_account} = PaymentMethod.find(paypal_account.token)

    assert found_paypal_account.email == "jane.doe@example.com"
    assert found_paypal_account.token =~ ~r/^\w+$/
  end

  defp master_card do
    CreditCardNumbers.master_cards() |> List.first
  end
end
