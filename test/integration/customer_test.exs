defmodule Braintree.Integration.CustomerTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.Customer
  alias Braintree.Testing.CreditCardNumbers
  alias Braintree.Testing.CreditCardNumbers.FailsSandboxVerification

  def master_card do
    CreditCardNumbers.master_cards |> List.first
  end

  test "create/1 without any params" do
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

  test "create/1 with a credit card" do
    {:ok, customer} = Customer.create(
      first_name: "Parker",
      last_name: "Selbert",
      credit_card: %{
        number: master_card,
        expiration_date: "01/2016",
        cvv: "100"
      }
    )

    assert customer.first_name == "Parker"
    assert customer.last_name == "Selbert"

    [card] = customer.credit_cards

    assert card.bin == String.slice(master_card, 0..5)
    assert card.last_4 == String.slice(master_card, -4..-1)
    assert card.expiration_month == "01"
    assert card.expiration_year == "2016"
    assert card.unique_number_identifier =~ ~r/\A\w{32}\z/
  end

  test "create/1 with card verification" do
    {:error, error} = Customer.create(
      first_name: "Parker",
      last_name: "Selbert",
      credit_card: %{
        number: FailsSandboxVerification.master_card,
        expiration_date: "01/2016",
        options: %{verify_card: true}
      }
    )

    error.message =~ "processor_declined"
  end
end
