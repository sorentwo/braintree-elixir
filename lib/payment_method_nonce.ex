defmodule Braintree.PaymentMethodNonce do
  @moduledoc """
  Create a payment method nonce from an existing payment method token
  """

  use Braintree.Construction

  alias Braintree.HTTP

  @type t :: %__MODULE__{
          default: String.t(),
          description: String.t(),
          nonce: String.t(),
          three_d_secure_info: String.t(),
          type: String.t(),
          details: map,
          is_locked: boolean,
          consumed: boolean,
          security_questions: [any]
        }

  defstruct default: nil,
            description: nil,
            nonce: nil,
            three_d_secure_info: nil,
            type: nil,
            is_locked: false,
            details: nil,
            consumed: false,
            security_questions: nil

  @doc """
  Create a payment method nonce from `token`

  ## Example

      {:ok, payment_method_nonce} = Braintree.PaymentMethodNonce.create(token)

      payment_method_nonce.nonce
  """
  @spec create(String.t(), Keyword.t()) :: {:ok, t} | HTTP.error()
  def create(payment_method_token, opts \\ []) do
    path = "payment_methods/#{payment_method_token}/nonces"

    with {:ok, payload} <- HTTP.post(path, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Find a payment method nonce, or return an error response if token invalid

  ## Example

      {:ok, payment_method} = Braintree.PaymentMethodNonce.find(token)

      payment_method.type #CreditCard
  """
  @spec find(String.t(), Keyword.t()) :: {:ok, t} | HTTP.error()
  def find(nonce, opts \\ []) do
    path = "payment_method_nonces/" <> nonce

    with {:ok, payload} <- HTTP.get(path, opts) do
      {:ok, new(payload)}
    end
  end

  @doc false
  def new(%{"payment_method_nonce" => map}) do
    super(map)
  end
end
