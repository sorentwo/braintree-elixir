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
    customer = Customer.new(%{
      "company" => "Soren",
      "email" => "parker@example.com",
      "credit_cards" => [%{
        "bin" => "12345",
        "card_type" => "Visa"
      }],
      "paypal_accounts" => [%{
        "email" => "parker@example.com",
        "token" => "t0k3n"
      }]
    })

    assert Enum.any?(customer.credit_cards)
    assert Enum.any?(customer.paypal_accounts)

    [card] = customer.credit_cards

    assert card.bin == "12345"
    assert card.card_type == "Visa"

    [paypal] = customer.paypal_accounts

    assert paypal.email == "parker@example.com"
    assert paypal.token == "t0k3n"
  end
end
