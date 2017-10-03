defmodule Braintree.Integration.CustomerTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.Customer
  alias Braintree.Testing.CreditCardNumbers
  alias Braintree.Testing.CreditCardNumbers.FailsSandboxVerification

  describe "create/1" do
    test "without any params" do
      assert {:ok, _customer} = Customer.create()
    end

    test "create/1 with valid params" do
      {:ok, customer} = Customer.create(%{
        first_name: "Bill",
        last_name: "Gates",
        company: "Microsoft",
        email: "bill@microsoft.com",
        phone: "312.555.1234",
        website: "www.microsoft.com"
      })

      assert customer.id =~ ~r/^\d+$/
      assert customer.first_name == "Bill"
      assert customer.last_name == "Gates"
      assert customer.company == "Microsoft"
      assert customer.email == "bill@microsoft.com"
      assert customer.phone == "312.555.1234"
      assert customer.website == "www.microsoft.com"
      assert customer.created_at
      assert customer.updated_at
    end

    test "with a credit card" do
      {:ok, customer} = Customer.create(%{
        first_name: "Parker",
        last_name: "Selbert",
        credit_card: %{
          number: master_card(),
          expiration_date: "01/2016",
          cvv: "100"
        }
      })

      assert customer.first_name == "Parker"
      assert customer.last_name == "Selbert"

      [card] = customer.credit_cards

      assert card.bin == String.slice(master_card(), 0..5)
      assert card.last_4 == String.slice(master_card(), -4..-1)
      assert card.expiration_month == "01"
      assert card.expiration_year == "2016"
      assert card.unique_number_identifier =~ ~r/\A\w{32}\z/
    end

    test "with card verification" do
      {:error, error} = Customer.create(%{
        first_name: "Parker",
        last_name: "Selbert",
        credit_card: %{
          number: FailsSandboxVerification.master_card(),
          expiration_date: "01/2016",
          options: %{verify_card: true}
        }
      })

      assert error.message =~ ~r/cvv is required/i
    end
  end

  describe "find/1" do
    test "retrieves an existing customer" do
      {:ok, original} = Customer.create(%{first_name: "Parker"})
      {:ok, customer} = Customer.find(original.id)

      assert customer.first_name == "Parker"
    end

    test "returns a not found error" do
      assert {:error, :not_found} = Customer.find("fakecustomerid")
    end
  end

  describe "update/2" do
    test "updates an existing customer" do
      {:ok, original} = Customer.create(%{first_name: "Parker"})
      {:ok, customer} = Customer.update(original.id, %{first_name: "Rekrap"})

      assert customer.first_name == "Rekrap"
    end

    test "exposes an error when updating fails" do
      invalid_company = repeatedly("a", 300)

      {:ok, customer} = Customer.create()
      {:error, error} = Customer.update(customer.id, %{company: invalid_company})

      assert error.message =~ ~r/company is too long/i
    end
  end

  describe "delete/1" do
    test "removes an existing customer" do
      {:ok, customer} = Customer.create()

      assert :ok = Customer.delete(customer.id)
    end
  end

  describe "search/1" do
    test "with valid params" do
      {:ok, _customer} = Customer.create(%{
        first_name: "Jenna",
        last_name: "Smith",
      })

      search_params = %{first_name: %{is: "Jenna"},
        last_name: %{
          starts_with: "Smith",
          contains: "ith",
          is_not: "Smithsonian"
        },
    }
      {:ok, [%Customer{} = customer | _]} = Customer.search(search_params)

      assert customer.first_name == "Jenna"
      assert customer.last_name == "Smith"
    end

    test "returns not found if no result" do
      assert {:error, :not_found} = Customer.search(%{first_name: %{is: "Mickael"}})
    end

    test "returns server error for invalid search params" do
      assert {:error, :server_error} = Customer.search(%{})
    end
  end

  defp master_card do
    CreditCardNumbers.master_cards() |> List.first
  end

  defp repeatedly(string, len) do
    fun = fn -> string end

    fun
    |> Stream.repeatedly()
    |> Enum.take(len)
    |> Enum.join
  end
end
