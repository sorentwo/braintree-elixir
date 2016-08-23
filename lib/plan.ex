defmodule Braintree.Plan do
  @moduledoc """
  Plans represent recurring billing plans in a Braintree merchant account.
  The API for plans is read only.

  For additional reference see:
  https://developers.braintreepayments.com/reference/request/plan/all/ruby
  """

  use Braintree.Construction

  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

  @type t :: %__MODULE__{
               id:                         String.t,
               add_ons:                    [],
               balance:                    String.t,
               billing_day_of_month:       String.t,
               billing_frequency:          String.t,
               created_at:                 String.t,
               currency_iso_code:          String.t,
               description:                String.t,
               discounts:                  [],
               name:                       String.t,
               number_of_billing_cycles:   String.t,
               price:                      String.t,
               trial_duration:             String.t,
               trial_duration_unit:        String.t,
               trial_period:               String.t,
               updated_at:                 String.t
             }

  defstruct id:                         nil,
            add_ons:                    [],
            balance:                    nil,
            billing_day_of_month:       nil,
            billing_frequency:          nil,
            created_at:                 nil,
            currency_iso_code:          nil,
            description:                nil,
            discounts:                  [],
            name:                       nil,
            number_of_billing_cycles:   nil,
            price:                      nil,
            trial_duration:             nil,
            trial_duration_unit:        nil,
            trial_period:               nil,
            updated_at:                 nil

  @doc """
  Get a list of all the plans defined in the merchant account. If there are
  no plans an empty list is returned.

  ## Example

      {:ok, plans} = Braintree.Plan.all()
  """
  @spec all() :: {:ok, [t]} | {:error, Error.t}
  def all do
    case HTTP.get("plans") do
      {:ok, %{"plans" => plans}} ->
        {:ok, construct(plans)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end
end
