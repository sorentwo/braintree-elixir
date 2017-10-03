defmodule Braintree.Merchant.FundingTest do
  use ExUnit.Case, async: true

  alias Braintree.Merchant.Funding

  test "all funding attributes are included" do
    funding = %Funding{
      descriptor: "descriptor",
      destination: "bank",
      email: "email@braintree.com",
      mobile_phone: "1234567890",
      routing_number: "00001111",
      account_number_last_4: "4141"
    }

    assert funding.descriptor == "descriptor"
    assert funding.destination == "bank"
    assert funding.email == "email@braintree.com"
    assert funding.mobile_phone == "1234567890"
    assert funding.routing_number == "00001111"
    assert funding.account_number_last_4 == "4141"
  end

  test "new/1 creates struct" do
    funding = Funding.new(%{"descriptor" => "descriptor"})

    assert funding.descriptor == "descriptor"
  end
end
