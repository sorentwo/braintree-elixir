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

  test "construct/1 converts a map to known structs" do
    customer = Customer.construct(%{
      "company" => "Soren",
      "email" => "parker@example.com",
      "credit_cards" => [%{
        "bin" => "12345",
        "card_type" => "Visa"
      }]
    })

    assert customer.company == "Soren"
    assert Enum.any?(customer.credit_cards)

    [card] = customer.credit_cards

    assert card.bin == "12345"
    assert card.card_type == "Visa"
  end
end
