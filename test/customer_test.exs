defmodule Braintree.CustomerTest do
  use ExUnit.Case, async: true

  test "all customer attributes are included" do
    customer = %Braintree.Customer{
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
end
