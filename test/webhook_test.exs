defmodule Braintree.WebhookTest do
  use ExUnit.Case, async: true

  alias Braintree.Test.Support.WebhookTestHelper
  alias Braintree.Webhook

  describe "Webhook#parse/2" do
    setup do
      %{"bt_payload" => _payload, "bt_signature" => _signature} =
        WebhookTestHelper.sample_notification("check", nil, "source_merchant_123")
    end

    test "returns decoded payload tuple with valid signature and payload", %{
      "bt_payload" => payload,
      "bt_signature" => signature
    } do
      assert {:ok, parsed} = Webhook.parse(signature, payload)

      assert parsed["payload"] =~ "<notification>"
      assert parsed["payload"] =~ "<kind>check</kind>"
      assert parsed["signature"] =~ ~r/\w{18}|\w{40}/
    end

    test "returns error tuple with invalid signature", %{"bt_payload" => payload} do
      assert {:error, "No matching public key"} = Webhook.parse("fake_signature", payload)
    end

    test "returns error tuple with invalid payload", %{"bt_signature" => signature} do
      assert {:error, "Signature does not match payload, one has been modified"} =
               Webhook.parse(signature, "fake_payload")
    end

    test "returns error tuple with nil payload", %{"bt_signature" => signature} do
      assert {:error, "Payload cannot be nil"} = Webhook.parse(signature, nil)
    end

    test "returns error tuple with nil signature", %{"bt_payload" => payload} do
      assert {:error, "Signature cannot be nil"} = Webhook.parse(nil, payload)
    end
  end
end
