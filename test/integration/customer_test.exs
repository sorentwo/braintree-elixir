defmodule Braintree.Integration.CustomerTest do
  use ExUnit.Case, async: true

  alias Braintree.Customer

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
end
