defmodule Braintree.Subscription do
  @moduledoc """
  Manage customer subscriptions to recurring billing plans.

  For additional reference see:
  https://developers.braintreepayments.com/reference/request/subscription/create/ruby
  """

  use Braintree.Construction

  alias Braintree.{AddOn, HTTP, Search, Transaction}

  @type t :: %__MODULE__{
          id: String.t(),
          plan_id: String.t(),
          balance: String.t(),
          billing_day_of_month: String.t(),
          billing_period_end_date: String.t(),
          billing_period_start_date: String.t(),
          created_at: String.t(),
          current_billing_cycle: String.t(),
          days_past_due: String.t(),
          descriptor: String.t(),
          failure_count: String.t(),
          first_billing_date: String.t(),
          merchant_account_id: String.t(),
          never_expires: String.t(),
          next_bill_amount: String.t(),
          next_billing_date: String.t(),
          next_billing_period_amount: String.t(),
          number_of_billing_cycles: String.t(),
          paid_through_date: String.t(),
          payment_method_token: String.t(),
          price: String.t(),
          status: String.t(),
          trial_duration: String.t(),
          trial_duration_unit: String.t(),
          trial_period: String.t(),
          updated_at: String.t(),
          add_ons: [AddOn.t()],
          discounts: [any],
          transactions: [Transaction.t()],
          status_history: [any]
        }

  defstruct id: nil,
            plan_id: nil,
            balance: nil,
            billing_day_of_month: nil,
            billing_period_end_date: nil,
            billing_period_start_date: nil,
            created_at: nil,
            current_billing_cycle: nil,
            days_past_due: nil,
            descriptor: nil,
            failure_count: nil,
            first_billing_date: nil,
            merchant_account_id: nil,
            never_expires: nil,
            next_bill_amount: nil,
            next_billing_date: nil,
            next_billing_period_amount: nil,
            number_of_billing_cycles: nil,
            paid_through_date: nil,
            payment_method_token: nil,
            price: nil,
            status: nil,
            trial_duration: nil,
            trial_duration_unit: nil,
            trial_period: nil,
            updated_at: nil,
            add_ons: [],
            discounts: [],
            transactions: [],
            status_history: []

  @doc """
  Create a subscription, or return an error response with after failed
  validation.

  ## Example

      {:ok, sub} = Braintree.Subscription.create(%{
        payment_method_token: card.token,
        plan_id: "starter"
      })
  """
  @spec create(map, Keyword.t()) :: {:ok, t} | HTTP.error()
  def create(params \\ %{}, opts \\ []) do
    with {:ok, payload} <- HTTP.post("subscriptions", %{subscription: params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Find an existing subscription by `subscription_id`

  ## Example

      {:ok, subscription} = Subscription.find("123")
  """
  @spec find(String.t(), Keyword.t()) :: {:ok, t} | HTTP.error()
  def find(subscription_id, opts \\ []) do
    with {:ok, payload} <- HTTP.get("subscriptions/#{subscription_id}", opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Cancel an existing subscription by `subscription_id`. A cancelled subscription
  cannot be reactivated, you would need to create a new one.

  ## Example

      {:ok, subscription} = Subscription.cancel("123")
  """
  @spec cancel(String.t(), Keyword.t()) :: {:ok, t} | HTTP.error()
  def cancel(subscription_id, opts \\ []) do
    with {:ok, payload} <- HTTP.put("subscriptions/#{subscription_id}/cancel", opts) do
      {:ok, new(payload)}
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
  @spec retry_charge(String.t()) :: {:ok, Transaction.t()}
  @spec retry_charge(String.t(), String.t() | nil, Keyword.t()) ::
          {:ok, Transaction.t()} | HTTP.error()
  def retry_charge(subscription_id, amount \\ nil, opts \\ []) do
    Transaction.sale(%{amount: amount, subscription_id: subscription_id}, opts)
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
  @spec update(binary, map, Keyword.t()) :: {:ok, t} | HTTP.error()
  def update(id, params, opts \\ []) when is_binary(id) and is_map(params) do
    with {:ok, payload} <- HTTP.put("subscriptions/" <> id, %{subscription: params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  To search for subscriptions, pass a map of search parameters.

  ## Example:

    {:ok, subscriptions} = Braintree.Subscription.search(%{plan_id: %{is: "starter"}})
  """
  @spec search(map, Keyword.t()) :: {:ok, t} | HTTP.error()
  def search(params, opts \\ []) when is_map(params) do
    Search.perform(params, "subscriptions", &new/1, opts)
  end

  @doc """
  Convert a map into a Subscription struct. Add_ons and transactions
  are converted to a list of structs as well.

  ## Example

      subscripton = Braintree.Subscription.new(%{"plan_id" => "business",
                                                 "status" => "Active"})
  """
  def new(%{"subscription" => map}) do
    new(map)
  end

  def new(map) when is_map(map) do
    subscription = super(map)

    add_ons = AddOn.new(subscription.add_ons)
    transactions = Transaction.new(subscription.transactions)

    %{subscription | add_ons: add_ons, transactions: transactions}
  end

  def new(list) when is_list(list) do
    Enum.map(list, &new/1)
  end
end
