defmodule Braintree.Merchant.AccountTest do
  use ExUnit.Case, async: true

  alias Braintree.Address
  alias Braintree.Merchant.{Account, Business, Funding, Individual}

  test "merchant account includes all attributes" do
    merchant = %Account{
      id: "ladders-merchant",
      status: "pending",
      currency_iso_code: "USD",
      default: true,
      master_merchant_account: "ladders_store",
      individual: %Individual{first_name: "Jane", address: %Address{street_address: "101 N Main St"}},
      business: %Business{legal_name: "Ladders.io", address: %Address{street_address: "102 N Main St"}},
      funding: %Funding{account_number_last_4: "7890"}
    }

    assert merchant.id == "ladders-merchant"
    assert merchant.status == "pending"
    assert merchant.currency_iso_code == "USD"
    assert merchant.default == true
    assert merchant.master_merchant_account == "ladders_store"
    assert merchant.individual.first_name == "Jane"
    assert merchant.individual.address.street_address == "101 N Main St"
    assert merchant.business.legal_name == "Ladders.io"
    assert merchant.business.address.street_address == "102 N Main St"
    assert merchant.funding.account_number_last_4 == "7890"
  end

  test "new/1 works with all sub-modules" do
    data = %{
      "merchant_account" =>
      %{
        "id" => "ladders-merchant",
        "status" => "pending",
        "currency_iso_code" => "USD",
        "default" => true,
        "master_merchant_account" => "ladders_store",
        "individual" => %{
          "first_name" => "Jane",
          "address" => %{
            "street_address" => "101 N Main St"
          }
        },
        "business" => %{
          "legal_name" => "Ladders.io",
          "address" => %{
            "street_address" => "102 N Main St",
          }
        },
        "funding" => %{
          "account_number_last_4" => "7890"
        }
      }
    }

    merchant = Account.new(data)

    assert merchant.id == "ladders-merchant"
    assert merchant.status == "pending"
    assert merchant.currency_iso_code == "USD"
    assert merchant.default == true
    assert merchant.master_merchant_account == "ladders_store"
    assert merchant.individual.first_name == "Jane"
    assert merchant.individual.address.street_address == "101 N Main St"
    assert merchant.business.legal_name == "Ladders.io"
    assert merchant.business.address.street_address == "102 N Main St"
    assert merchant.funding.account_number_last_4 == "7890"
  end
end
