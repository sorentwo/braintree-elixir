defmodule Braintree.AddOnTest do
  use ExUnit.Case, async: true

  alias Braintree.AddOn

  test "construct/1 creates structs with default values" do
    [addon] = AddOn.construct([%{"id" => "123"}])

    assert addon.amount == 0
    refute addon.never_expires?
    assert addon.number_of_billing_cycles == 0
    assert addon.quantity == 0
  end
end
