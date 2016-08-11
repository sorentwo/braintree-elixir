defmodule Braintree.Integration.DiscountTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.Discount

  describe "all/0" do
    test "it gets a successful listing of discounts" do
      {:ok, _any} = Discount.all()
    end
  end
end
