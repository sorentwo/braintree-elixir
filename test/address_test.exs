defmodule Braintree.AddressTest do
  use ExUnit.Case, async: true

  alias Braintree.Address

  test "all address attributes are included" do
    address = %Address{
      customer_id: "131866",
      first_name: "Jenna",
      last_name: "Smith",
      company: "Braintree",
      street_address: "1 E Main St",
      extended_address: "Suite 403",
      locality: "Chicago",
      region: "Illinois",
      postal_code: "60622",
      country_code_alpha2: "US",
      country_code_alpha3: "USA",
      country_code_numeric: "840",
      country_name: "United States of America"
    }

    assert address.id == nil
    assert address.customer_id == "131866"
    assert address.first_name == "Jenna"
    assert address.last_name == "Smith"
    assert address.company == "Braintree"
    assert address.street_address == "1 E Main St"
    assert address.extended_address == "Suite 403"
    assert address.locality == "Chicago"
    assert address.region == "Illinois"
    assert address.postal_code == "60622"
    assert address.country_code_alpha2 == "US"
    assert address.country_code_alpha3 == "USA"
    assert address.country_code_numeric == "840"
    assert address.country_name == "United States of America"
  end
end
