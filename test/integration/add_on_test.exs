defmodule Braintree.Integration.AddOnTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.AddOn

  # This test relies on there being at least one add on in the sandbox account.
  test "all/0 fetches all add ons" do
    {:ok, [add_on | _]} = AddOn.all()

    assert add_on
    assert add_on.id
    assert add_on.kind
    assert add_on.name
    refute add_on.amount == 0
  end
end
