defmodule Braintree.Integration.SubscriptionTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.{Customer, Subscription}

  def create_test_subscription do
    {:ok, customer} = Customer.create(%{payment_method_nonce: "fake-valid-nonce"})
    [card] = customer.credit_cards
    Subscription.create(%{payment_method_token: card.token, plan_id: "starter"})
  end

  test "create/1 with a plan_id and add_ons" do
    assert {:ok, customer} = Customer.create(%{payment_method_nonce: "fake-valid-nonce"})
    [card] = customer.credit_cards

    add_ons = %{add: [%{inherited_from_id: "gold"}],
                update: [%{existing_id: "silver", quantity: 2}],
                remove: ["bronze"]}

    assert {:ok, _subscription} = Subscription.create(%{payment_method_token: card.token,
                                                        plan_id: "business", add_ons: add_ons})
  end

  test "find/1 with a subscription_id" do
    {:ok, subscription} = create_test_subscription
    assert {:ok, subscription} = Subscription.find(subscription.id)

    assert subscription.plan_id == "starter"
    assert %Subscription{} = subscription
  end

  test "cancel/1 with a subscription_id" do
    {:ok, subscription} = create_test_subscription
    assert {:ok, subscription} = Subscription.cancel(subscription.id)

    assert subscription.status == "Canceled"
    assert %Subscription{} = subscription
  end

  test "retry_charge/1" do
    {:ok, subscription} = create_test_subscription

    assert {:error, error} = Subscription.retry_charge(subscription.id)
    assert error.message =~ "Subscription status must be Past Due in order to retry."
  end

  test "update/2 with a subscription_id" do
    {:ok, subscription} = create_test_subscription

    assert {:ok, subscription} = Subscription.update(subscription.id, %{
      plan_id: "business",
      price: "16.99"
    })

    assert subscription.plan_id == "business"
    assert subscription.price == "16.99"
  end
end
