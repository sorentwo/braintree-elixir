defmodule Braintree.Integration.SubscriptionTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.Customer
  alias Braintree.Subscription

  test "create/1 with a plan_id" do
    assert {:ok, customer} = Customer.create(%{payment_method_nonce: "fake-valid-nonce"})
    card = customer.credit_cards |> List.first
    assert {:ok, _subscription } = Subscription.create(%{payment_method_token: card.token, plan_id: "starter"})
  end
end
