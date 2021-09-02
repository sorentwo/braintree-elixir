defmodule Braintree.Webhook.Digest do
  @moduledoc """
  This module provides convenience methods to help validate Braintree signatures and associated payloads for webhooks.
  """

  @doc """
  A wrapper function that does a secure comparision accounting for timing attacks.
  """
  @spec secure_compare(String.t(), String.t()) :: boolean()
  def secure_compare(left, right) when is_binary(left) and is_binary(right) do
    Plug.Crypto.secure_compare(left, right)
  end

  def secure_compare(_, _), do: false

  @doc """
  Returns the message as a hex-encoded string to validate it matches the signature from the braintree webhook event.
  """
  @spec hexdigest(String.t() | nil, String.t() | nil) :: String.t()
  def hexdigest(nil, _), do: ""
  def hexdigest(_, nil), do: ""

  def hexdigest(private_key, message) do
    key_digest = :crypto.hash(:sha, private_key)

    :sha
    |> hmac(key_digest, message)
    |> Base.encode16(case: :lower)
  end

  if System.otp_release() >= "22" do
    defp hmac(digest, key, data), do: :crypto.mac(:hmac, digest, key, data)
  else
    defp hmac(digest, key, data), do: :crypto.hmac(digest, key, data)
  end
end
