defmodule Braintree.MerchantAccountTest do
  use ExUnit.Case, async: true

  alias Braintree.{Address, MerchantAccount}
  alias Braintree.Merchant.{Individual, Business, Funding}

  test "merchant account includes all attributes" do
    merchant = %MerchantAccount{
      id: "ladders-merchant",
      status: "pending",
      currency_iso_code: "USD",
      default: true,
      master_merchant_account: "ladders_store",
      individual_details: %Individual{first_name: "Jane", address_details: %Address{street_address: "101 N Main St"}},
      business_details: %Business{legal_name: "Ladders.io", address_details: %Address{street_address: "102 N Main St"}},
      funding_details: %Funding{account_number: "1234567890"}
    }

    assert merchant.id == "ladders-merchant"
    assert merchant.status == "pending"
    assert merchant.currency_iso_code == "USD"
    assert merchant.default == true
    assert merchant.master_merchant_account == "ladders_store"
    assert merchant.individual_details.first_name == "Jane"
    assert merchant.individual_details.address_details.street_address == "101 N Main St"
    assert merchant.business_details.legal_name == "Ladders.io"
    assert merchant.business_details.address_details.street_address == "102 N Main St"
    assert merchant.funding_details.account_number == "1234567890"
  end

  test "new/1 works with all sub-modules" do
    data = %{
      "id" => "ladders-merchant",
      "status" => "pending",
      "currency_iso_code" => "USD",
      "default" => true,
      "master_merchant_account" => "ladders_store",
      "individual_details" => %{
        "first_name" => "Jane",
        "address_details" => %{
          "street_address" => "101 N Main St"
        }
      },
      "business_details" => %{
        "legal_name" => "Ladders.io",
        "address_details" => %{
          "street_address" => "102 N Main St",
        }
      },
      "funding_details" => %{
        "account_number" => "1234567890"
      }
    }


    merchant = MerchantAccount.new(data)

    assert merchant.id == "ladders-merchant"
    assert merchant.status == "pending"
    assert merchant.currency_iso_code == "USD"
    assert merchant.default == true
    assert merchant.master_merchant_account == "ladders_store"
    assert merchant.individual_details.first_name == "Jane"
    assert merchant.individual_details.address_details.street_address == "101 N Main St"
    assert merchant.business_details.legal_name == "Ladders.io"
    assert merchant.business_details.address_details.street_address == "102 N Main St"
    assert merchant.funding_details.account_number == "1234567890"
  end
end
