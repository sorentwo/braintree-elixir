defmodule Braintree.Integration.MerchantAccountTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.MerchantAccount

  @master_merchant_id Braintree.get_env(:master_merchant_id)

  describe "create/1" do
    test "without any params" do
      assert {:error, :server_error} = MerchantAccount.create()
    end

    test "with valid params" do
      assert {:ok, merchant} = MerchantAccount.create(merchant_params())

      refute merchant.id == nil
    end

    test "with invalid params" do
      params = %{"tos_accepted" => false, "master_merchant_account_id" => @master_merchant_id}

      assert {:error, error} = MerchantAccount.create(params)
      assert error.message == "Terms Of Service needs to be accepted. Applicant tos_accepted required."
    end
  end

  describe "update/2" do
    test "with valid params" do
      {:ok, merchant} = MerchantAccount.create(merchant_params())
      {:ok, merchant} = MerchantAccount.update(merchant.id, %{funding: %{account_number: "00001111"}})

      assert merchant.funding.account_number_last_4 == "1111"
    end

    test "with invalid params" do
      {:ok, merchant} = MerchantAccount.create(merchant_params())
      assert {:error, error} = MerchantAccount.update(merchant.id, %{funding: %{destination: "Somewhere under the rainbow"}})

      assert error.message == "Funding destination is invalid."
    end

    test "with non existent merchant" do
      assert {:error, :not_found} = MerchantAccount.update("invalid-merchant-id", %{funding: %{account_number: "1212121"}})
    end
  end

  describe "find/1" do
    test "with valid merchant ID" do
      assert {:ok, merchant} = MerchantAccount.create(merchant_params())

      assert {:ok, _merchant} = MerchantAccount.find(merchant.id)
    end

    test "not found with invalid merchant ID" do
      assert {:error, :not_found} = MerchantAccount.find("invalid-merchant-id")
    end
  end

  @params %{
    individual: %{
      first_name: "Jane",
      last_name: "Doe",
      email: "jane@14ladders.com",
      phone: "5553334444",
      date_of_birth: "1981-11-19",
      ssn: "456-45-4567",
      address: %{
        street_address: "111 Main St",
        locality: "Chicago",
        region: "IL",
        postal_code: "60622"
      }
    },
    business: %{
      legal_name: "Jane's Ladders",
      dba_name: "Jane's Ladders",
      tax_id: "98-7654321",
      address: %{
        street_address: "111 Main St",
        locality: "Chicago",
        region: "IL",
        postal_code: "60622"
      }
    },
    funding: %{
      descriptor: "Blue Ladders",
      destination: "bank",
      email: "funding@blueladders.com",
      mobile_phone: "5555555555",
      account_number: "1123581321",
      routing_number: "071101307"
    },
    tos_accepted: true,
    master_merchant_account_id: @master_merchant_id,
  }

  def merchant_params, do: @params
  def merchant_id, do: "ladders_store_#{:rand.uniform(10000)}"
end
