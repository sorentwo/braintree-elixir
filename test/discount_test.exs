defmodule Braintree.DiscountTest do
  use ExUnit.Case, async: true

  alias Braintree.Discount

  describe "construct/1" do
    test "builds a sane struct" do
      discount = Discount.construct(%{
        "id" => "asdf1234",
        "amount" => "25.00"
      })

      assert discount.id == "asdf1234"
      refute discount.never_expires?
      assert discount.number_of_billing_cycles == 0
    end
  end
end
