defmodule Braintree.PaymentMethodNonce do
  @moduledoc """
  Create a payment method nonce from an existing payment method token
  """

  use Braintree.Construction

  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

  @type t :: %__MODULE__{
               default:             String.t,
               description:         String.t,
               nonce:               String.t,
               three_d_secure_info: String.t,
               type:                String.t,
               details:             Map.t,
               is_locked:           boolean,
               consumed:            boolean,
               security_questions:  []
             }

  defstruct default:              nil,
            description:          nil,
            nonce:                nil,
            three_d_secure_info:  nil,
            type:                 nil,
            is_locked:            false,
            details:              nil,
            consumed:             false,
            security_questions:   nil

  @doc """
  Create a payment method nonce from `token`

  ## Example

      {:ok, payment_method_nonce} = Braintree.PaymentMethodNonce.create(token)

      payment_method_nonce.nonce
  """
  @spec create(String.t) :: {:ok, t} | {:error, Error.t}
  def create(payment_method_token) do
    path = "payment_methods/#{payment_method_token}/nonces"

    with {:ok, payload} <- HTTP.post(path) do
      {:ok, construct(payload)}
    end
  end

  @doc """
  Find a payment method nonce, or return an error response if token invalid

  ## Example

      {:ok, payment_method} = Braintree.PaymentMethodNonce.find(token)

      payment_method.type #CreditCard
  """
  @spec find(String.t) :: {:ok, t} | {:error, Error.t}
  def find(nonce) do
    path = "payment_method_nonces/" <> nonce

    with {:ok, payload} <- HTTP.get(path) do
      {:ok, construct(payload)}
    end
  end

  @doc false
  @spec construct(Map.t) :: t
  def construct(%{"payment_method_nonce" => map}) do
    super(map)
  end
end
