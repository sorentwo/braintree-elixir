defmodule Braintree.Test.Support.WebhookTestHelper do
  @moduledoc false

  alias Braintree.Webhook.Digest

  def sample_notification(kind, id, source_merchant_id \\ nil) do
    payload = Base.encode64(sample_xml(kind, id, source_merchant_id))

    signature_string =
      "#{braintree_public_key()}|#{Digest.hexdigest(braintree_private_key(), payload)}"

    %{"bt_signature" => signature_string, "bt_payload" => payload}
  end

  def sample_xml(kind, data, datetime, source_merchant_id \\ nil) do
    source_merchant_xml =
      if source_merchant_id == nil do
        "<source-merchant-id>#{source_merchant_id}</source-merchant-id>"
      else
        nil
      end

    ~s"""
    <notification>
      <timestamp type="datetime">#{datetime}</timestamp>
      <kind>#{kind}</kind>
      #{source_merchant_xml}
      <subject>
        #{subject_sample_xml(kind, data)}
      </subject>
    </notification>
    """
  end

  defp subject_sample_xml(_kind, _id) do
    ~s"""
    <check type="boolean">true</check>
    """
  end

  defp braintree_public_key, do: Braintree.get_env(:public_key, "public_key")
  defp braintree_private_key, do: Braintree.get_env(:private_key, "private_key")
end
