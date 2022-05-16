defmodule Braintree.Integration.PlanTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.Plan

  # Create a new plan for testing and delete on exit
  setup_all do
    {:ok, %Plan{} = existing_plan} =
      Plan.create(%{
        name: "testing_plan_#{System.unique_integer([:positive])}",
        billing_frequency: 1,
        currency_iso_code: "USD",
        price: "10.00"
      })

    on_exit(fn -> Plan.delete(existing_plan.id) end)

    %{existing_plan: existing_plan}
  end

  test "all/0 fetches all plans", %{existing_plan: existing_plan} do
    {:ok, [%Plan{} = plan | _] = plans} = Plan.all()

    assert plan
    assert plan.id
    assert plan.name
    assert Enum.any?(plans, fn plan -> plan.id == existing_plan.id end)
  end

  test "create/0 creates a new plan" do
    {:ok, %Plan{} = plan} =
      Plan.create(%{
        name: "testing_create_plan",
        billing_frequency: 1,
        currency_iso_code: "USD",
        price: "10.00"
      })

    assert plan
    assert plan.id
    assert plan.name == "testing_create_plan"
    assert plan.price == "10.00"

    :ok = Plan.delete(plan.id)
  end

  test "find/1 finds a plan", %{existing_plan: existing_plan} do
    {:ok, %Plan{} = plan} = Plan.find(existing_plan.id)

    assert plan
    assert plan.id
    assert plan.name == existing_plan.name
  end

  test "update/2 updates a plan", %{existing_plan: existing_plan} do
    {:ok, %Plan{} = plan} = Plan.update(existing_plan.id, %{name: "updated_name"})

    assert plan
    assert plan.id == existing_plan.id
    assert plan.name == "updated_name"

    # Cleanup and revert back to old name
    {:ok, %Plan{}} = Plan.update(existing_plan.id, %{name: existing_plan.name})
  end

  test "delete/1 deletes a plan" do
    {:ok, %Plan{id: id}} =
      Plan.create(%{
        name: "testing_delete_plan",
        billing_frequency: 1,
        currency_iso_code: "USD",
        price: "10.00"
      })

    :ok = Plan.delete(id)
    {:ok, plans} = Plan.all()

    assert Enum.all?(plans, fn plan -> plan.id != id end)
  end
end
