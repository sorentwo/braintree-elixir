defmodule Braintree.Integration.SettlementBatchSummaryTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.SettlementBatchSummary, as: Summary

  test "generate/1 displays total sales and credits for a period" do
    {:ok, %Summary{} = summary} = Summary.generate("2016-09-06")

    assert summary
    assert summary.records
  end
end
