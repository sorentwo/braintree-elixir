defmodule Braintree.AddOn do
  @moduledoc """
  Add-ons and discounts are created in the Control Panel. You cannot create or
  update them through the API.

  Add-ons and discounts can be applied manually on a case-by-case basis, or you
  can associate them with certain plans to apply them automatically to new
  subscriptions. When creating a subscription, it will automatically inherit
  any add-ons and/or discounts associated with the plan. You can override those
  details at the time you create or update the subscription.
  """

  use Braintree.Construction

  alias Braintree.HTTP

  @type t :: %__MODULE__{
               id:                       String.t,
               amount:                   String.t,
               current_billing_cycle:    integer,
               description:              String.t,
               kind:                     String.t,
               name:                     String.t,
               never_expires?:           boolean,
               number_of_billing_cycles: integer,
               quantity:                 integer
             }

  defstruct id:                       nil,
            amount:                   0,
            current_billing_cycle:    nil,
            description:              nil,
            kind:                     nil,
            name:                     nil,
            never_expires?:           false,
            number_of_billing_cycles: 0,
            quantity:                 0

  @doc """
  Returns a list of Braintree::AddOn structs.

  ## Example

      {:ok, addons} = Braintree.AddOns.all()
  """
  @spec all() :: {:ok, [t]} | {:error, Error.t}
  def all do
    with {:ok, %{"add_ons" => add_ons}} <- HTTP.get("add_ons") do
      {:ok, new(add_ons)}
    end
  end
end
