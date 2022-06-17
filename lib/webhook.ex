defmodule Braintree.Webhook do
  @moduledoc """
  This module provides convenience methods for parsing Braintree webhook payloads.
  """

  alias Braintree.Webhook.Validation

  @doc """
  Return a map containing the payload and signature from the braintree webhook event.
  """
  @spec parse(String.t() | nil, String.t() | nil, Keyword.t()) ::
          {:ok, map} | {:error, String.t()}
  def parse(signature, payload, opts \\ [])
  def parse(nil, _payload, _opts), do: {:error, "Signature cannot be nil"}
  def parse(_sig, nil, _opts), do: {:error, "Payload cannot be nil"}

  def parse(sig, payload, opts) do
    with :ok <- Validation.validate_signature(sig, payload, opts),
         {:ok, decoded} <- Base.decode64(payload, ignore: :whitespace) do
      {:ok, %{"payload" => decoded, "signature" => sig}}
    else
      :error -> {:error, "Could not decode payload"}
      {:error, error_msg} -> {:error, error_msg}
    end
  end
end
