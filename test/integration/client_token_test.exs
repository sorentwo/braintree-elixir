defmodule Braintree.Integration.ClientToken do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.{ClientToken,Customer}

  test "generate/1 without any params" do
    {:ok, _client_token} = ClientToken.generate()
  end

  test "generate/1 with a customer id" do
    {:ok, customer} = Customer.create()
    {:ok, client_token} = ClientToken.generate(%{customer_id: customer.id})

    assert client_token
    assert client_token =~ ~r/.+/
  end

  test "generate/1 with a bogus customer" do
    {:error, error} = ClientToken.generate(%{customer_id: "asdfghjkl"})
  end
end
