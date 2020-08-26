defmodule Braintree.Integration.PaymentMethodTest do
  use ExUnit.Case, async: true

  alias Braintree.{Customer, PaymentMethod, PaymentMethodNonce}
  alias Braintree.Testing.{CreditCardNumbers, Nonces}

  @moduletag :integration

  test "create/1 fails when customer_id not provided" do
    {:error, error} =
      PaymentMethod.create(%{
        payment_method_nonce: Nonces.transactable()
      })

    assert error.message == "Customer ID is required."
  end

  test "create/1 fails when payment_method_nonce not provided" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Bill",
        last_name: "Gates"
      })

    {:error, error} =
      PaymentMethod.create(%{
        customer_id: customer.id
      })

    assert error.message == "Nonce is required."
  end

  test "create/1 can create a payment method from an existing customer and fake nonce" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Bill",
        last_name: "Gates"
      })

    {:ok, payment_method} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Nonces.transactable()
      })

    assert payment_method.card_type == "Visa"
    assert payment_method.bin =~ ~r/^\w+$/
  end

  test "create/1 can create a payment method from a vaulted credit card nonce" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Rick",
        last_name: "Grimes",
        credit_card: %{
          number: master_card(),
          expiration_date: "01/2016",
          cvv: "100"
        }
      })

    [card] = customer.credit_cards
    {:ok, payment_method_nonce} = PaymentMethodNonce.create(card.token)

    {:ok, payment_method} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: payment_method_nonce.nonce
      })

    assert payment_method.card_type == "MasterCard"
    assert payment_method.bin =~ card.bin
  end

  test "create/1 can create an ApplePay payment method" do
    {:ok, %{id: customer_id}} =
      Customer.create(%{
        first_name: "Rick",
        last_name: "Grimes"
      })

    assert {:ok,
            %Braintree.ApplePayCard{
              billing_address: nil,
              bin: "401288",
              card_type: "Apple Pay - Visa",
              cardholder_name: "Visa Apple Pay Cardholder",
              created_at: "" <> _,
              customer_id: ^customer_id,
              default: true,
              expiration_month: "12",
              expiration_year: "2020",
              expired: false,
              image_url:
                "https://assets.braintreegateway.com/payment_method_logo/apple_pay.png?environment=sandbox",
              last_4: "1881",
              payment_instrument_name: "Visa 8886",
              source_description: "Visa 8886",
              subscriptions: [],
              token: "" <> _,
              updated_at: "" <> _
            }} =
             PaymentMethod.create(%{
               customer_id: customer_id,
               payment_method_nonce: Nonces.apple_pay_visa()
             })
  end

  test "create/1 can create an AndroidPay payment method" do
    {:ok, %{id: customer_id}} =
      Customer.create(%{
        first_name: "Rick",
        last_name: "Grimes"
      })

    assert {:ok,
            %Braintree.AndroidPayCard{
              bin: "401288",
              created_at: "" <> _,
              customer_id: ^customer_id,
              default: true,
              expiration_month: "12",
              expiration_year: "2025",
              google_transaction_id: "google_transaction_id",
              image_url:
                "https://assets.braintreegateway.com/payment_method_logo/android_pay_card.png?environment=sandbox",
              is_network_tokenized: true,
              source_card_last_4: "1111",
              source_card_type: "Visa",
              source_description: "Visa 1111",
              subscriptions: [],
              token: "" <> _,
              updated_at: "" <> _,
              virtual_card_last_4: "1881",
              virtual_card_type: "Visa"
            }} =
             PaymentMethod.create(%{
               customer_id: customer_id,
               payment_method_nonce: Nonces.android_pay_visa_nonce()
             })
  end

  test "create/1 can create a paypal payment method" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Rick",
        last_name: "Grimes"
      })

    {:ok, paypal_account} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Nonces.paypal_future_payment()
      })

    assert paypal_account.email == "jane.doe@paypal.com"
    assert paypal_account.token =~ ~r/^\w+$/
  end

  test "create/1 can successfully make paypal payment method the default" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Bill",
        last_name: "Gates"
      })

    {:ok, paypal_account} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Nonces.paypal_future_payment(),
        options: %{make_default: true}
      })

    assert paypal_account.default == true
  end

  test "update/1 fails when invalid token provided" do
    assert {:error, :not_found} = PaymentMethod.update("bogus")
  end

  test "update/2 can successfully update existing payment_method" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Bill",
        last_name: "Gates"
      })

    {:ok, payment_method} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        cardholder_name: "Bruce",
        payment_method_nonce: Nonces.transactable()
      })

    assert payment_method.cardholder_name == "Bruce"

    {:ok, updated_method} =
      PaymentMethod.update(payment_method.token, %{
        cardholder_name: "Steve"
      })

    assert updated_method.cardholder_name == "Steve"
  end

  test "update/2 can successfully call update on a paypal payment method" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Bill",
        last_name: "Gates"
      })

    {:ok, paypal_account} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Nonces.paypal_future_payment()
      })

    assert {:ok, _} =
             PaymentMethod.update(paypal_account.token, %{options: %{make_default: true}})
  end

  test "delete/1 succeeds when valid token provided" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Bill",
        last_name: "Gates"
      })

    {:ok, payment_method} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Nonces.transactable()
      })

    assert :ok = PaymentMethod.delete(payment_method.token)
  end

  test "delete/1 can delete paypal payment method" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Bill",
        last_name: "Gates"
      })

    {:ok, paypal_account} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Nonces.paypal_future_payment()
      })

    assert :ok = PaymentMethod.delete(paypal_account.token)
  end

  test "find/1 succeeds when valid token provided" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Bill",
        last_name: "Gates"
      })

    {:ok, payment_method} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Nonces.transactable()
      })

    {:ok, found_payment} = PaymentMethod.find(payment_method.token)

    assert found_payment.cardholder_name == payment_method.cardholder_name
    assert found_payment.card_type == payment_method.card_type
    assert found_payment.token == payment_method.token
  end

  test "find/1 can find an existing paypal payment method" do
    {:ok, customer} =
      Customer.create(%{
        first_name: "Bill",
        last_name: "Gates"
      })

    {:ok, paypal_account} =
      PaymentMethod.create(%{
        customer_id: customer.id,
        payment_method_nonce: Nonces.paypal_future_payment()
      })

    {:ok, found_paypal_account} = PaymentMethod.find(paypal_account.token)

    assert found_paypal_account.email == "jane.doe@paypal.com"
    assert found_paypal_account.token =~ ~r/^\w+$/
  end

  defp master_card do
    CreditCardNumbers.master_cards() |> List.first()
  end
end
