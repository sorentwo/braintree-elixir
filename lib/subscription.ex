defmodule Braintree.Subscription do
  @moduledoc """
  Manage customer subscriptions to reocurring billing plans.

  For additional reference see:
  https://developers.braintreepayments.com/reference/request/subscription/create/ruby
  """

  use Braintree.Construction

  alias Braintree.ErrorResponse, as: Error
  alias Braintree.{HTTP, Transaction}

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

      {:ok, sub} = Braintree.Subscription.create(%{payment_method_token: card.token, plan_id: "starter"})
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

  @doc """
  Find an existing subscription by `subscription_id`

  ## Example

      {:ok, subscription} = Subscription.find("123")
  """
  @spec find(String.t) :: {:ok, t} | {:error, Error.t}
  def find(subscription_id) do
    case HTTP.get("subscriptions/#{subscription_id}") do
      {:ok, %{"subscription" => subscription}} ->
        {:ok, construct(subscription)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "subscription id is invalid"})}
    end
  end

  @doc """
  Cancel an existing subscription by `subscription_id`. A cancelled subscription
  cannot be reactivated, you would need to create a new one.

  ## Example

      {:ok, subscription} = Subscription.cancel("123")
  """
  @spec cancel(String.t) :: {:ok, t} | {:error, Error.t}
  def cancel(subscription_id) do
    case HTTP.put("subscriptions/#{subscription_id}/cancel") do
      {:ok, %{"subscription" => subscription}} ->
        {:ok, construct(subscription)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "subscription id is invalid"})}
    end
  end

  @doc """
  You can manually retry charging past due subscriptions.

  By default, we will use the subscription balance when retrying the
  transaction. If you would like to use a different amount you can optionally
  specify the amount for the transaction.

  A successful manual retry of a past due subscription will **always** reduce
  the balance of that subscription to $0, regardless of the amount of the
  retry.

  ## Example

      {:ok, transaction} = Braintree.Subscription.retry_charge(sub_id)
      {:ok, transaction} = Braintree.Subscription.retry_charge(sub_id, "24.00")
  """
  @spec retry_charge(String.t) :: {:ok, Transaction.t}
  @spec retry_charge(String.t, String.t | nil) :: {:ok, Transaction.t} | {:error, Error.t}
  def retry_charge(subscription_id, amount \\ nil) do
    Transaction.sale(%{amount: amount, subscription_id: subscription_id})
  end

  @doc """
  To update a subscription, use its ID along with new attributes. The same
  validations apply as when creating a subscription. Any attribute not passed will
  remain unchanged.

  ## Example

      {:ok, subscription} = Braintree.Subscription.update("subscription_id", %{
        plan_id: "new_plan_id"
      })
      subscription.plan_id # "new_plan_id"
  """
  @spec update(binary, Map.t) :: {:ok, t} | {:error, Error.t}
  def update(id, params) when is_binary(id) and is_map(params) do
    case HTTP.put("subscriptions/" <> id, %{subscription: params}) do
      {:ok, %{"subscription" => subscription}} ->
        {:ok, construct(subscription)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
      {:error, :not_found} ->
        {:error, Error.construct(%{"message" => "subscription id is invalid"})}
    end
  end
end
