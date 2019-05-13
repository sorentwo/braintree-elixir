defmodule Braintree.Integration.AddressTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.Address

  setup do
    {:ok, customer} =
      Braintree.Customer.create(%{
        first_name: "Test",
        last_name: "User"
      })

    {:ok, customer: customer}
  end

  describe "create/2" do
    test "fails without any params", %{customer: customer} do
      assert {:error, _address} = Address.create(customer.id)
    end

    test "succeeds with valid params", %{customer: customer} do
      {:ok, address} =
        Address.create(customer.id, %{
          first_name: "Jenna",
          last_name: "Smith",
          company: "Braintree",
          street_address: "1 E Main St",
          extended_address: "Suite 403",
          locality: "Chicago",
          region: "Illinois",
          postal_code: "60622",
          country_code_alpha2: "US"
        })

      assert address.customer_id == customer.id
      assert address.country_name == "United States of America"
      assert address.first_name == "Jenna"
      assert address.last_name == "Smith"
      assert address.company == "Braintree"
      assert address.street_address == "1 E Main St"
      assert address.extended_address == "Suite 403"
      assert address.locality == "Chicago"
      assert address.region == "Illinois"
      assert address.postal_code == "60622"
    end

    test "with invalid customer id" do
      assert {:error, :not_found} =
               Address.create("invalid-customer", %{first_name: "Jenna", last_name: "Smith"})
    end
  end

  describe "delete/2" do
    test "deletes an existing address", %{customer: customer} do
      {:ok, address} = Address.create(customer.id, %{first_name: "Jenna"})

      assert :ok = Address.delete(customer.id, address.id)
    end

    test "returns not found for invalid address id", %{customer: customer} do
      assert {:error, :not_found} = Address.delete(customer.id, "invalid-address")
    end

    test "returns not found for invalid customer id", %{customer: customer} do
      {:ok, address} = Address.create(customer.id, %{first_name: "Jenna"})

      assert {:error, :not_found} = Address.delete("invalid-customer", address.id)
    end
  end

  describe "update/3" do
    test "updates/3 with valid params", %{customer: customer} do
      {:ok, address} = Address.create(customer.id, %{first_name: "Jenna"})

      assert {:ok, address} = Address.update(customer.id, address.id, %{last_name: "Smith"})

      assert address.customer_id == customer.id
      assert address.first_name == "Jenna"
      assert address.last_name == "Smith"
    end

    test "updates/3 an address that does not exist", %{customer: customer} do
      assert {:error, :not_found} =
               Address.update(customer.id, "invalid-address", %{last_name: "Smith"})
    end

    test "updates/3 an existing address with invalid params", %{customer: customer} do
      {:ok, address} = Address.create(customer.id, %{first_name: "Jenna"})

      assert {:error, error} =
               Address.update(customer.id, address.id, %{
                 country_code_numeric: "invalid country code"
               })

      assert error.message == "Country code (numeric) is not an accepted country."
    end
  end

  describe "find/2" do
    test "retrieves an existing address", %{customer: customer} do
      {:ok, address} = Address.create(customer.id, %{first_name: "Jenna"})
      assert {:ok, address} = Address.find(customer.id, address.id)

      assert address.first_name == "Jenna"
    end

    test "returns not found if address does not exist", %{customer: customer} do
      assert {:error, :not_found} = Address.find(customer.id, "invalid-address")
    end

    test "returns not found if customer does not exist", %{customer: customer} do
      {:ok, address} = Address.create(customer.id, %{first_name: "Jenna"})
      assert {:error, :not_found} = Address.find("invalid-customer", address.id)
    end
  end
end
