defmodule Braintree.Integration.SubscriptionTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.Customer
  alias Braintree.Subscription

  def create_test_subscription do
    {:ok, customer} = Customer.create(%{payment_method_nonce: "fake-valid-nonce"})
    [card] = customer.credit_cards
    Subscription.create(%{payment_method_token: card.token, plan_id: "starter"})
  end

  test "create/1 with a plan_id" do
    assert {:ok, customer} = Customer.create(%{payment_method_nonce: "fake-valid-nonce"})
    [card] = customer.credit_cards
    assert {:ok, _subscription} = Subscription.create(%{payment_method_token: card.token, plan_id: "starter"})
  end

  test "find/1 with a subscription_id" do
    {:ok, subscription} = create_test_subscription
    assert {:ok, _subscription} = Subscription.find(subscription.id)
  end

  test "cancel/1 with a subscription_id" do
    {:ok, subscription} = create_test_subscription
    assert {:ok, _subscription} = Subscription.cancel(subscription.id)
  end
end
