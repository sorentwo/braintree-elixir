defmodule Braintree.Merchant.IndividualTest do
  use ExUnit.Case, async: true

  alias Braintree.Address
  alias Braintree.Merchant.Individual

  test "all individual attributes are included" do
    individual = %Individual{
      first_name: "Jenna",
      last_name: "Smith",
      email: "smith@braintree.com",
      phone: "1234567890",
      date_of_birth: "01-09-1990",
      ssn_last_4: "2222",
      address: %Address{
        street_address: "101 N Main St"
      }
    }

    assert individual.first_name == "Jenna"
    assert individual.last_name == "Smith"
    assert individual.email == "smith@braintree.com"
    assert individual.phone == "1234567890"
    assert individual.date_of_birth == "01-09-1990"
    assert individual.ssn_last_4 == "2222"
    assert individual.address.street_address == "101 N Main St"
  end

  test "new/1 with address" do
    individual =
      Individual.new(%{
        "address" => %{"street_address" => "101 N Main St"},
        "first_name" => "Jenna"
      })

    assert individual.first_name == "Jenna"
    assert individual.address.street_address == "101 N Main St"
  end
end
