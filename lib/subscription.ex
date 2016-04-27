defmodule Braintree.Subscription do
  @moduledoc """
  Manage customer subscriptions to reocurring billing plans.

  For additional reference see:
  https://developers.braintreepayments.com/reference/request/subscription/create/ruby
  """

  import Braintree.Util, only: [atomize: 1]

  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

  @type t :: %__MODULE__{
               id:                         String.t,
               plan_id:                    String.t,
               balance:                    String.t,
               billing_day_of_month:       String.t,
               billing_period_end_date:    String.t,
               billing_period_start_date:  String.t,
               created_at:                 String.t,
               current_billing_cycle:      String.t,
               days_past_due:              String.t,
               descriptor:                 String.t,
               failure_count:              String.t,
               first_billing_date:         String.t,
               merchant_account_id:        String.t,
               never_expires:              String.t,
               next_bill_amount:           String.t,
               next_billing_date:          String.t,
               next_billing_period_amount: String.t,
               number_of_billing_cycles:   String.t,
               paid_through_date:          String.t,
               payment_method_token:       String.t,
               price:                      String.t,
               status:                     String.t,
               trial_duration:             String.t,
               trial_duration_unit:        String.t,
               trial_period:               String.t,
               updated_at:                 String.t,
               add_ons:                    [],
               discounts:                  [],
               transactions:               [],
               status_history:             []
             }

  defstruct id:                         nil,
            plan_id:                    nil,
            balance:                    nil,
            billing_day_of_month:       nil,
            billing_period_end_date:    nil,
            billing_period_start_date:  nil,
            created_at:                 nil,
            current_billing_cycle:      nil,
            days_past_due:              nil,
            descriptor:                 nil,
            failure_count:              nil,
            first_billing_date:         nil,
            merchant_account_id:        nil,
            never_expires:              nil,
            next_bill_amount:           nil,
            next_billing_date:          nil,
            next_billing_period_amount: nil,
            number_of_billing_cycles:   nil,
            paid_through_date:          nil,
            payment_method_token:       nil,
            price:                      nil,
            status:                     nil,
            trial_duration:             nil,
            trial_duration_unit:        nil,
            trial_period:               nil,
            updated_at:                 nil,
            add_ons:                    [],
            discounts:                  [],
            transactions:               [],
            status_history:             []

  @doc """
  Create a subscription, or return an error response with after failed
  validation.

  ## Example

      {:ok, customer} = Braintree.Customer.create(%{payment_method_nonce: "fake-valid-nonce"})
      {:ok, subscription} = Braintree.Subscription.create(%{})

      customer.company # Braintree
  """
  @spec create(Map.t) :: {:ok, t} | {:error, Error.t}
  def create(params \\ %{}) do
    case HTTP.post("subscriptions", %{subscription: params}) do
      {:ok, %{"subscription" => subscription}} ->
        {:ok, construct(subscription)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end

  @doc false
  @spec construct(Map.t) :: t
  def construct(map) do
    struct(__MODULE__, atomize(map))
  end
end
