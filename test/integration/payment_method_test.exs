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

  test "update/1 fails when invalid token provided" do
    {:error, error} = PaymentMethod.update("bogus")

    assert error.message == "Token is invalid."
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

    {:ok, updated_payment_method} = PaymentMethod.update(payment_method.token, %{
        cardholder_name: "Steve"
      })

    assert updated_payment_method.cardholder_name == "Steve"
  end

  test "delete/1 fails when invalid token provided" do
    {:error, error} = PaymentMethod.delete("bogus")

    assert error.message == "Token is invalid."
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

  test "find/1 fails when invalid token provided" do
    {:error, error} = PaymentMethod.find("bogus")

    assert error.message == "Token is invalid."
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

  defp master_card do
    CreditCardNumbers.master_cards() |> List.first
  end
end
