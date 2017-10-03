defmodule Braintree.CreditCardVerificationTest do
  use ExUnit.Case, async: true

  alias Braintree.{CreditCardVerification, Address, CreditCard}

  test "all credit card verification attributes are included" do
    verification = %CreditCardVerification{
      amount: "45.30",
      avs_error_response_code: "E",
      avs_postal_code_response_code: "E",
      avs_street_address_response_code: "E",
      billing: %Address{first_name: "Jenna"},
      created_at: "now",
      credit_card: %CreditCard{cardholder_name: "Jenna Smith"},
      currency_iso_code: "usd",
      cvv_response_code: "E",
      gateway_rejection_reason: "gateway_declined",
      id: "1",
      merchant_account_id: "2",
      processor_response_code: "A",
      processor_response_text: "B",
      risk_data: %{decision: "Approved"},
      status: "failed"
    }

    assert verification.amount == "45.30"
    assert verification.avs_error_response_code == "E"
    assert verification.avs_postal_code_response_code == "E"
    assert verification.avs_street_address_response_code == "E"
    assert verification.billing == %Address{first_name: "Jenna"}
    assert verification.created_at == "now"
    assert verification.credit_card == %CreditCard{cardholder_name: "Jenna Smith"}
    assert verification.currency_iso_code == "usd"
    assert verification.cvv_response_code == "E"
    assert verification.gateway_rejection_reason == "gateway_declined"
    assert verification.id == "1"
    assert verification.merchant_account_id == "2"
    assert verification.processor_response_code == "A"
    assert verification.processor_response_text == "B"
    assert verification.risk_data == %{decision: "Approved"}
    assert verification.status == "failed"
  end
end
