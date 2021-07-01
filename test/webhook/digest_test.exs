defmodule Braintree.Webhook.DigestTest do
  use ExUnit.Case, async: true

  alias Braintree.Webhook.Digest

  describe "WebhookDigest#hexdigest/2" do
    test "returns the sha1 hmac of the input string (test case 6 from RFC 2202)" do
      private_key = String.duplicate("\xaa", 80)
      data = "Test Using Larger Than Block-Size Key - Hash Key First"
      assert Digest.hexdigest(private_key, data) == "aa4ae5e15272d00e95705637ce8a3b55ed402112"
    end

    test "returns the sha1 hmac of the input string (test case 7 from RFC 2202)" do
      private_key = String.duplicate("\xaa", 80)
      data = "Test Using Larger Than Block-Size Key and Larger Than One Block-Size Data"
      assert Digest.hexdigest(private_key, data) == "e8e99d0f45237d786d6bbaa7965c7808bbff1a91"
    end

    test "doesn't blow up if message is nil" do
      assert Digest.hexdigest("key", nil) == ""
    end

    test "doesn't blow up if key is nil" do
      assert Digest.hexdigest(nil, "key") == ""
    end
  end

  describe "Digest#secure_compare/2" do
    test "returns true if two strings are equal" do
      assert Digest.secure_compare("A_string", "A_string") == true
    end

    test "returns false if two strings are different and the same length" do
      assert Digest.secure_compare("A_string", "A_strong") == false
    end

    test "returns false if one is a prefix of the other" do
      assert Digest.secure_compare("A_string", "A_string_that_is_longer") == false
    end
  end
end
