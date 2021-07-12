defmodule Braintree.Webhook.Digest do
  @moduledoc """
  This module provides convenience methods to help validate Braintree signatures and associated payloads for webhooks.
  """

  @spec secure_compare(String.t(), String.t()) :: boolean()
  @doc """
  A wrapper function that does a secure comparision accounting for timing attacks.
  """
  def secure_compare(left, right) when is_binary(left) and is_binary(right),
    do: Plug.Crypto.secure_compare(left, right)

  def secure_compare(_, _), do: false

  @spec hexdigest(String.t() | nil, String.t() | nil) :: String.t()
  @doc """
  Returns the message as a hex-encoded string to validate it matches the signature from the braintree webhook event.
  """
  def hexdigest(nil, _), do: ""
  def hexdigest(_, nil), do: ""

  def hexdigest(private_key, message) do
    key_digest = :crypto.hash(:sha, private_key)

    hmac(:sha, key_digest, message)
    |> Base.encode16(case: :lower)
  end

  # TODO: remove when we require OTP 22
  if System.otp_release() >= "22" do
    defp hmac(digest, key, data), do: :crypto.mac(:hmac, digest, key, data)
  else
    defp hmac(digest, key, data), do: :crypto.hmac(digest, key, data)
  end
end
