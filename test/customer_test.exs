defmodule Braintree.CustomerTest do
  use ExUnit.Case, async: true

  alias Braintree.Customer

  test "all customer attributes are included" do
    customer = %Customer{
      company: "Soren",
      email: "parker@example.com",
      first_name: "Parker",
      last_name: "Selbert"
    }

    assert customer.id == nil
    assert customer.company == "Soren"
    assert customer.email == "parker@example.com"
    assert customer.first_name == "Parker"
    assert customer.last_name == "Selbert"

    assert customer.addresses == []
    assert customer.credit_cards == []
    assert customer.paypal_accounts == []
  end

  test "new/1 converts nested payment methods to a list of known structs" do
    customer =
      Customer.new(%{
        "company" => "Soren",
        "email" => "parker@example.com",
        "apple_pay_cards" => [
          %{
            "billing_address" => %{"postal_code" => "222222"},
            "bin" => "401288",
            "card_type" => "Apple Pay - Visa",
            "cardholder_name" => "Visa Apple Pay Cardholder",
            "created_at" => "2020-08-13T22:13:55Z",
            "customer_global_id" => "Y3VzdG9tZXJfMjI1OTU0MTI5",
            "customer_id" => "225954129",
            "default" => false,
            "expiration_month" => "12",
            "expiration_year" => "2020",
            "expired" => false,
            "global_id" => "cGF5bWVudG1ldGhvZF9hcHBsZV9tcnQycHRi",
            "image_url" =>
              "https://assets.braintreegateway.com/payment_method_logo/apple_pay.png?environment=sandbox",
            "last_4" => "1881",
            "payment_instrument_name" => "Visa 8886",
            "source_description" => "Visa 8886",
            "subscriptions" => [],
            "token" => "mrt2ptb",
            "updated_at" => "2020-08-13T22:13:55Z"
          }
        ],
        "credit_cards" => [
          %{
            "bin" => "12345",
            "card_type" => "Visa"
          }
        ],
        "paypal_accounts" => [
          %{
            "email" => "parker@example.com",
            "token" => "t0k3n"
          }
        ]
      })

    assert Enum.any?(customer.apple_pay_cards)
    assert Enum.any?(customer.credit_cards)
    assert Enum.any?(customer.paypal_accounts)

    [apple_pay_card] = customer.apple_pay_cards

    assert apple_pay_card == %Braintree.ApplePayCard{
             billing_address: %{postal_code: "222222"},
             bin: "401288",
             card_type: "Apple Pay - Visa",
             cardholder_name: "Visa Apple Pay Cardholder",
             created_at: "2020-08-13T22:13:55Z",
             customer_global_id: "Y3VzdG9tZXJfMjI1OTU0MTI5",
             customer_id: "225954129",
             default: false,
             expiration_month: "12",
             expiration_year: "2020",
             expired: false,
             global_id: "cGF5bWVudG1ldGhvZF9hcHBsZV9tcnQycHRi",
             image_url:
               "https://assets.braintreegateway.com/payment_method_logo/apple_pay.png?environment=sandbox",
             last_4: "1881",
             payment_instrument_name: "Visa 8886",
             source_description: "Visa 8886",
             subscriptions: [],
             token: "mrt2ptb",
             updated_at: "2020-08-13T22:13:55Z"
           }

    [card] = customer.credit_cards

    assert card.bin == "12345"
    assert card.card_type == "Visa"

    [paypal] = customer.paypal_accounts

    assert paypal.email == "parker@example.com"
    assert paypal.token == "t0k3n"
  end
end
