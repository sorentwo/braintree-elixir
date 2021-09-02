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
      assert Webhook.parse(signature, payload) ==
               {:ok,
                %{
                  "payload" =>
                    "<notification>\n  <timestamp type=\"datetime\">2021-06-24T23:41:58Z</timestamp>\n  <kind>check</kind>\n  \n  <subject>\n    <check type=\"boolean\">true</check>\n\n  </subject>\n</notification>\n",
                  "signature" => "public_key|4261b2771e7852348af5103d7f98b6148bb9ad1b"
                }}
    end

    test "returns error tuple with invalid signature", %{"bt_payload" => payload} do
      assert Webhook.parse("fake_signature", payload) ==
               {:error, "No matching public key"}
    end

    test "returns error tuple with invalid payload", %{"bt_signature" => signature} do
      assert Webhook.parse(signature, "fake_payload") ==
               {:error, "Signature does not match payload, one has been modified"}
    end

    test "returns error tuple with nil payload", %{"bt_signature" => signature} do
      assert Webhook.parse(signature, nil) == {:error, "Payload cannot be nil"}
    end

    test "returns error tuple with nil signature", %{"bt_payload" => payload} do
      assert Webhook.parse(nil, payload) == {:error, "Signature cannot be nil"}
    end
  end
end
