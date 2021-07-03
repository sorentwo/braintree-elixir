defmodule Braintree.Webhook do
  @moduledoc """
  This module provides convenience methods for parsing Braintree webhook payloads.
  """
  alias Braintree.Webhook.Validation

  @doc """
  Return a map containing the payload and signature from the braintree webhook event.
  """
  @spec parse(String.t() | nil, String.t() | nil) :: {:ok, map} | {:error, String.t()}
  def parse(nil, _payload), do: {:error, "Signature cannot be nil"}
  def parse(_sig, nil), do: {:error, "Payload cannot be nil"}

  def parse(sig, payload) do
    with :ok <- Validation.validate_signature(sig, payload),
         {:ok, decoded} <- Base.decode64(payload, ignore: :whitespace) do
      {:ok, %{"payload" => decoded, "signature" => sig}}
    else
      :error -> {:error, "Could not decode payload"}
      {:error, error_msg} -> {:error, error_msg}
    end
  end
end
