defmodule Braintree.PaymentMethodNonce do
  @moduledoc """
  Create a payment method nonce from an existing payment method token
  """
  @type t :: %__MODULE__{
               default:                  String.t,
               description:              String.t,
               nonce:                    String.t,
               three_d_secure_info:      String.t,
               type:                     String.t,
               details:                  Map.t,
               is_locked:                boolean,
               consumed:                 boolean,
               security_questions:       []
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

  import Braintree.Util, only: [atomize: 1]
  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error
  
  @doc """
  Create a payment method nonce from `token`

  ## Example

      {:ok, payment_method_nonce} = Braintree.PaymentMethodNonce.create(token)
      
      payment_method_nonce.nonce
  """
  @spec create(String.t) :: {:ok, t} | {:error, Error.t}
  def create(payment_method_token) do
    case HTTP.post("payment_methods/#{payment_method_token}/nonces", %{}) do
      {:ok, %{"payment_method_nonce" => payment_method_nonce}} ->
        {:ok, construct(payment_method_nonce)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} -> 
        {:error, Error.construct(%{"message" => "Token is invalid."})}
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
    case HTTP.get("payment_method_nonces/#{nonce}") do
      {:ok, %{"payment_method_nonce" => payment_method_nonce}} ->
        {:ok, construct(payment_method_nonce)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} -> 
        {:error, Error.construct(%{"message" => "Token is invalid."})}
    end
  end
  
  def construct(map) do
    struct(__MODULE__, atomize(map))
  end
end
