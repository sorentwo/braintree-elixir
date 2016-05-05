defmodule Braintree.Plan do
  @moduledoc """
  Get information about braintree plans

  For additional reference see:
  https://developers.braintreepayments.com/reference/request/plan/all/ruby
  """

  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

  @doc """
  Get all existing plans or a error response.

  ## Example

      {:ok, plans} = Braintree.Plan.all()

      plans # All the existing plans
  """
  def all do
    case HTTP.get("plans") do
      {:ok, %{"plans" => plans}} ->
        plans
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end
end