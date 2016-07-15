defmodule Braintree.Integration.PlanTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.Plan

  test "all/0 can successfully get a response" do
    {:ok, _} = Plan.all
  end
end
