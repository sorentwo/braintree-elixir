defmodule Braintree.VenmoAccount do
  @moduledoc """
  Find, update and delete Venmo Accounts using PaymentMethod token
  """

  use Braintree.Construction

  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

  @type t :: %__MODULE__{
               created_at:           String.t,
               customer_id:          String.t,
               global_id:            String.t,
               image_url:            String.t,
               token:                String.t,
               source_description:   String.t,
               updated_at:           String.t,
               username:             String.t,
               venmo_user_id:        String.t,
               default:              boolean,
               subscriptions:        []
             }

  defstruct billing_agreement_id: nil,
            created_at:           nil,
            customer_id:          nil,
            global_id:            nil,
            image_url:            nil,
            token:                nil,
            source_description:   nil,
            updated_at:           nil,
            username:             nil,
            venmo_user_id:        nil,
            default:              false,
            subscriptions:        []
  @doc """
  Find a venmo account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, venmo_account} = Braintree.VenmoAccount.find(token)
  """
  @spec find(String.t) :: {:ok, t} | {:error, Error.t}
  def find(token) do
    case HTTP.get("payment_methods/venmo_account/#{token}") do
      {:ok, %{"venmo_account" => venmo_account}} ->
        {:ok, construct(venmo_account)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "venmo token is invalid"})}
    end
  end

  @doc """
  Update a venmo account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, venmo_account} = Braintree.VenmoAccount.update(
        token,
        %{options: %{make_default: true}
      )
  """
  @spec update(String.t, Map.t) :: {:ok, t} | {:error, Error.t}
  def update(token, params) do
    case HTTP.put("payment_methods/venmo_account/#{token}", %{venmo_account: params}) do
      {:ok, %{"venmo_account" => venmo_account}} ->
        {:ok, construct(venmo_account)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "venmo token is invalid"})}
    end
  end

  @doc """
  Delete a venmo account record using `token` or return an error
  response if the token is invalid.

  ## Example

      {:ok, venmo_account} = Braintree.VenmoAccount.delete(token)
  """
  @spec delete(String.t) :: {:ok, t} | {:error, Error.t}
  def delete(token) do
    case HTTP.delete("payment_methods/venmo_account/#{token}") do
      {:ok, %{}} ->
        {:ok, "Success"}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "venmo token is invalid"})}
    end
  end
end
