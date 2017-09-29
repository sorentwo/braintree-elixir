defmodule Braintree.Merchant.BusinessTest do
  use ExUnit.Case, async: true

  alias Braintree.Merchant.Business

  test "all business attributes are included" do
    business = %Business{
      legal_name: "Ladders.io",
      dba_name: "Ladders",
      tax_id: "123456",
      address: %{
        street_address: "10 Ladders St"
      }
    }

    assert business.legal_name == "Ladders.io"
    assert business.dba_name == "Ladders"
    assert business.tax_id == "123456"
    assert business.address.street_address == "10 Ladders St"
  end

  test "new/1 with address" do
    business = Business.new(%{"address" => %{
                                "street_address" => "101 N Main St"
                              },
                              "legal_name" => "Ladders.io"
                            })

    assert business.legal_name == "Ladders.io"
    assert business.address.street_address == "101 N Main St"
  end
end
