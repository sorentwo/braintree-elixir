defmodule Braintree.Plan do
  @moduledoc """
  Plans represent recurring billing plans in a Braintree merchant account.
  The API for plans is read only.

  For additional reference see:
  https://developers.braintreepayments.com/reference/request/plan/all/ruby
  """

  use Braintree.Construction

  alias Braintree.HTTP

  @type t :: %__MODULE__{
          id: String.t(),
          add_ons: [any],
          balance: String.t(),
          billing_day_of_month: String.t(),
          billing_frequency: String.t(),
          created_at: String.t(),
          currency_iso_code: String.t(),
          description: String.t(),
          discounts: [any],
          name: String.t(),
          number_of_billing_cycles: String.t(),
          price: String.t(),
          trial_duration: String.t(),
          trial_duration_unit: String.t(),
          trial_period: String.t(),
          updated_at: String.t()
        }

  defstruct id: nil,
            add_ons: [],
            balance: nil,
            billing_day_of_month: nil,
            billing_frequency: nil,
            created_at: nil,
            currency_iso_code: nil,
            description: nil,
            discounts: [],
            name: nil,
            number_of_billing_cycles: nil,
            price: nil,
            trial_duration: nil,
            trial_duration_unit: nil,
            trial_period: nil,
            updated_at: nil

  @doc """
  Get a list of all the plans defined in the merchant account. If there are
  no plans an empty list is returned.

  ## Example

      {:ok, plans} = Braintree.Plan.all()
  """
  @spec all(Keyword.t()) :: {:ok, [t]} | HTTP.error()
  def all(opts \\ []) do
    with {:ok, %{"plans" => plans}} <- HTTP.get("plans", opts) do
      {:ok, new(plans)}
    end
  end

  @doc """
  Create a new plan under a merchant account.

  ## Example

      {:ok, plan} = Braintree.Plan.create(%{
        name: "a plan",
        billing_frequency: 3,
        currency_iso_code: "USD",
        price: "10.00"
      })
  """
  @spec create(map, Keyword.t()) :: {:ok, t} | HTTP.error()
  def create(params, opts \\ []) do
    with {:ok, %{"plan" => plan}} <- HTTP.post("plans", %{plan: params}, opts) do
      {:ok, new(plan)}
    end
  end

  @doc """
  Get a specific plan defined in the merchant account by the plan id. If there is
  no plan with the specified id, `{:error, :not_found}` is returned.

  ## Example

      {:ok, plan} = Braintree.Plan.find("existing plan_id")

      {:error, :not_found} = Braintree.Plan.find("non-existing plan_id")
  """
  @spec find(String.t(), Keyword.t()) :: {:ok, t} | HTTP.error()
  def find(id, opts \\ []) when is_binary(id) do
    with {:ok, %{"plan" => plan}} <- HTTP.get("plans/#{id}", opts) do
      {:ok, new(plan)}
    end
  end

  @doc """
  Updates a specific plan defined in the merchant account by the plan id. If there is
  no plan with the specified id, `{:error, :not_found}` is returned.

  ## Example

      {:ok, updated_plan} = Braintree.Plan.find("existing plan_id", %{name: "new_name"})

      {:error, :not_found} = Braintree.Plan.find("non-existing plan_id")
  """
  @spec update(String.t(), map, Keyword.t()) :: {:ok, t} | HTTP.error()
  def update(id, params, opts \\ []) when is_binary(id) and is_map(params) do
    with {:ok, %{"plan" => plan}} <- HTTP.put("plans/#{id}", %{plan: params}, opts) do
      {:ok, new(plan)}
    end
  end

  @doc """
  Delete a plan defined in the merchant account by the plan id.
  A plan can't be deleted if it has any former or current subscriptions associated with it.
  If there is no plan with the specified id, `{:error, :not_found}` is returned.
  """
  @spec delete(String.t(), Keyword.t()) :: :ok | HTTP.error()
  def delete(id, opts \\ []) when is_binary(id) do
    with {:ok, _response} <- HTTP.delete("plans/#{id}", opts) do
      :ok
    end
  end
end
