defmodule Braintree.Webhook.ValidationTest do
  use ExUnit.Case, async: true

  alias Braintree.Webhook.Validation
  alias Braintree.Test.Support.WebhookTestHelper

  describe "Validation#validate_signature/2" do
    setup do
      %{"bt_payload" => _payload, "bt_signature" => _signature} =
        WebhookTestHelper.sample_notification("check", nil, "source_merchant_123")
    end

    test "returns :ok with valid signature and payload", %{
      "bt_payload" => payload,
      "bt_signature" => signature
    } do
      assert Validation.validate_signature(signature, payload) == :ok
    end

    test "returns error tuple with invalid signature", %{"bt_payload" => payload} do
      assert Validation.validate_signature("fake_signature", payload) ==
               {:error, "No matching public key"}
    end

    test "returns error tuple with invalid payload", %{"bt_signature" => signature} do
      assert Validation.validate_signature(signature, "fake_payload") ==
               {:error, "Signature does not match payload, one has been modified"}
    end

    test "returns error tuple with nil payload", %{"bt_signature" => signature} do
      assert Validation.validate_signature(signature, nil) == {:error, "Payload cannot be nil"}
    end

    test "returns error tuple with nil signature", %{"bt_payload" => payload} do
      assert Validation.validate_signature(nil, payload) == {:error, "Signature cannot be nil"}
    end
  end
end
