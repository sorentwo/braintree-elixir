defmodule Braintree.PlanTest do
  use ExUnit.Case, async: true

  alias Braintree.Plan

  test "construct/1 constructs a list of plans with nested maps available" do
    [first_plan, second_plan] = Plan.construct([%{
      "add_ons" => [],
      "balance" => nil,
      "billing_day_of_month" => nil,
      "billing_frequency" => 1,
      "created_at" => "2016-07-07T21:28:00Z",
      "currency_iso_code" => "USD",
      "description" => "Plan description",
      "discounts" => [],
      "id" => "1234",
      "name" => "Plan name",
      "number_of_billing_cycles" => nil,
      "price" => "14.99",
      "trial_duration" => nil,
      "trial_duration_unit" => nil,
      "trial_period" => false,
      "updated_at" => "2016-07-07T21:28:00Z"
    }, %{
      "add_ons" => [%{
        "amount" => "5.99",
        "merchant_id" => "12345"
      }],
      "balance" => nil,
      "billing_day_of_month" => nil,
      "billing_frequency" => 1,
      "created_at" => "2016-07-07T21:28:00Z",
      "currency_iso_code" => "USD",
      "description" => "Plan description",
      "discounts" => [],
      "id" => "5678",
      "name" => "Plan name",
      "number_of_billing_cycles" => nil,
      "price" => "14.99",
      "trial_duration" => nil,
      "trial_duration_unit" => nil,
      "trial_period" => false,
      "updated_at" => "2016-07-07T21:28:00Z"
    }])

    assert first_plan.add_ons == []
    assert first_plan.discounts == []

    assert second_plan.discounts == []

    [addon] = second_plan.add_ons

    assert addon["amount"] == "5.99"
    assert addon["merchant_id"] == "12345"
  end
end
