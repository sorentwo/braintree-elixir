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
end
