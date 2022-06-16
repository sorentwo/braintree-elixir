defmodule Braintree.Webhook.Validation do
  @moduledoc """
  This module provides convenience methods to help validate Braintree signatures and associated payloads for webhooks.
  """

  alias Braintree.Webhook.Digest

  @doc """
  Validate the webhook signature and payload from braintree.
  """
  @spec validate_signature(String.t() | nil, String.t() | nil, Keyword.t()) ::
          :ok | {:error, String.t()}
  def validate_signature(signature, payload, opts \\ [])
  def validate_signature(nil, _payload, _opts), do: {:error, "Signature cannot be nil"}
  def validate_signature(_sig, nil, _opts), do: {:error, "Payload cannot be nil"}

  def validate_signature(sig, payload, opts) do
    sig
    |> matching_sig_pair(opts)
    |> compare_sig_pair(payload, opts)
  end

  defp matching_sig_pair(sig_string, opts) do
    sig_string
    |> String.split("&")
    |> Enum.filter(&String.contains?(&1, "|"))
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.find([], fn [public_key, _signature] -> public_key == braintree_public_key(opts) end)
  end

  defp compare_sig_pair([], _, _), do: {:error, "No matching public key"}

  defp compare_sig_pair([_public_key, sig], payload, opts) do
    if Enum.any?([payload, payload <> "\n"], &secure_compare(sig, &1, opts)) do
      :ok
    else
      {:error, "Signature does not match payload, one has been modified"}
    end
  end

  defp secure_compare(signature, payload, opts) do
    payload_signature = Digest.hexdigest(braintree_private_key(opts), payload)

    Digest.secure_compare(signature, payload_signature)
  end

  defp braintree_public_key(opts),
    do: Keyword.get_lazy(opts, :public_key, fn -> Braintree.get_env(:public_key) end)

  defp braintree_private_key(opts),
    do: Keyword.get_lazy(opts, :private_key, fn -> Braintree.get_env(:private_key) end)
end
