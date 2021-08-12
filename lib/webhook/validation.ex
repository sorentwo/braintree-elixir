defmodule Braintree.Webhook.Validation do
  @moduledoc """
  This module provides convenience methods to help validate Braintree signatures and associated payloads for webhooks.
  """
  alias Braintree.Webhook.Digest

  @spec validate_signature(String.t() | nil, String.t() | nil) :: :ok | {:error, String.t()}
  @doc """
  Validate the webhook signature and payload from braintree.
  """
  def validate_signature(nil, _payload), do: {:error, "Signature cannot be nil"}
  def validate_signature(_sig, nil), do: {:error, "Payload cannot be nil"}

  def validate_signature(sig, payload) do
    sig
    |> matching_sig_pair()
    |> compare_sig_pair(payload)
  end

  defp matching_sig_pair(sig_string) do
    sig_string
    |> String.split("&")
    |> Enum.filter(&String.contains?(&1, "|"))
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.find([], fn [public_key, _signature] -> public_key == braintree_public_key() end)
  end

  defp compare_sig_pair([], _), do: {:error, "No matching public key"}

  defp compare_sig_pair([_public_key, sig], payload) do
    [payload, payload <> "\n"]
    |> Enum.any?(fn pload -> secure_compare(sig, pload) end)
    |> case do
      true -> :ok
      false -> {:error, "Signature does not match payload, one has been modified"}
    end
  end

  defp secure_compare(signature, payload) do
    payload_signature = Digest.hexdigest(braintree_private_key(), payload)
    Digest.secure_compare(signature, payload_signature)
  end

  defp braintree_public_key(), do: Braintree.get_env(:public_key)
  defp braintree_private_key(), do: Braintree.get_env(:private_key)
end
