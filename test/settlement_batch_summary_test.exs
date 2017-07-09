defmodule Braintree.SettlementBatchSummaryTest do
  use ExUnit.Case, async: true

  alias Braintree.SettlementBatchSummary, as: Summary

  describe "new/1" do
    test "creates a struct with record structs" do
      records = [%{"card_type" => "MasterCard",
                   "kind" => "sale",
                   "count" => "12",
                   "custom_field_1" => "value"}]

      summary = Summary.new(%{"records" => records})

      [record] = summary.records

      assert record.card_type == "MasterCard"
      assert record.count == "12"
      assert record.kind == "sale"
      assert record.custom_field_1 == "value"
    end
  end
end
