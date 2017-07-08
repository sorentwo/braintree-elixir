defmodule Braintree.Integration.ClientToken do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.{ClientToken, Customer}

  describe "generate/1" do
    test "without any params" do
      {:ok, client_token} = ClientToken.generate()

      assert client_token
      assert client_token =~ ~r/.+/
      refute client_token =~ "{\"version\":1"
    end

    test "with a custom version" do
      {:ok, client_token} = ClientToken.generate(%{version: 1})

      assert client_token =~ "{\"version\":1"
    end

    test "with a customer id" do
      {:ok, customer} = Customer.create()
      {:ok, client_token} = ClientToken.generate(%{customer_id: customer.id, version: 1})

      assert client_token
      assert client_token =~ ~r/.+/
    end

    test "with a bogus customer" do
      assert {:error, _} = ClientToken.generate(%{customer_id: "asdfghjkl"})
    end
  end
end
