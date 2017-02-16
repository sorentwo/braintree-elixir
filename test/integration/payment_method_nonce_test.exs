defmodule Braintree.Integration.PaymentMethodNonceTest do
  use ExUnit.Case, async: true

  alias Braintree.Customer
  alias Braintree.PaymentMethodNonce
  alias Braintree.Testing.CreditCardNumbers

  @moduletag :integration

  test "create/1 throws error message when provided invalid token" do
    {:error, error} = PaymentMethodNonce.create("invalid_token")

    assert error.message == "payment nonce is invalid"
  end

  test "create/1 succeeds when provided valid token" do
    {:ok, customer} = Customer.create(%{
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

    assert payment_method_nonce.type == "CreditCard"
  end

  test "find/1 fails when invalid nonce provided" do
    {:error, error} = PaymentMethodNonce.find("bogus")

    assert error.message == "payment nonce is invalid"
  end

  test "find/1 succeeds when valid token provided" do
    {:ok, customer} = Customer.create(%{
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

    {:ok, found_nonce} = PaymentMethodNonce.find(payment_method_nonce.nonce)

    assert found_nonce.type == payment_method_nonce.type
    assert found_nonce.nonce == payment_method_nonce.nonce
  end

  defp master_card do
    CreditCardNumbers.master_cards() |> List.first
  end
end
