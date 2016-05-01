defmodule Braintree.Plan do
  @moduledoc """
  Get information about braintree plans
  """

  alias Braintree.HTTP

  @doc """
  Get all existing plans or a empty list
  """
  def all do
    plans = HTTP.get("plans")
    case plans do
      {:ok, result} ->
        result
      {:error, _} ->
        []
    end
  end
end