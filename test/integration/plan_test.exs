defmodule Braintree.Integration.PlanTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.Plan

  # This relies on there being at least one plan in the sandbox account.
  test "all/0 fetches all plans" do
    {:ok, [%Plan{} = plan | _]} = Plan.all()

    assert plan
    assert plan.id
    assert plan.name
  end

  # This will create a new plan every time it's ran, make sure to cleanup if ran excessively
  test "create/0 creates a new plan" do
    {:ok, %Plan{} = plan} =
      Plan.create(%{
        name: "a plan",
        billing_frequency: 1,
        currency_iso_code: "USD",
        price: "10.00"
      })

    assert plan
    assert plan.id
    assert plan.name == "a plan"
    assert plan.price == "10.00"
  end

  # This relies on there being at least one plan in the sandbox account.
  test "find/1 finds a plan" do
    {:ok, [%Plan{id: existing_plan_id} | _]} = Plan.all()
    {:ok, %Plan{} = plan} = Plan.find(existing_plan_id)

    assert plan
    assert plan.id == existing_plan_id
  end

  # This relies on there being at least one plan in the sandbox account.
  test "update/2 updates a plan" do
    {:ok, [%Plan{id: existing_plan_id} | _]} = Plan.all()
    {:ok, %Plan{} = plan} = Plan.update(existing_plan_id, %{name: "updated_name"})

    assert plan
    assert plan.id
    assert plan.name == "updated_name"
  end
end
