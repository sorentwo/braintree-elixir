defmodule Braintree.Discount do
  @moduledoc """
  Add-ons and discounts are created in the Control Panel. You cannot create or update them through the API.

  Add-ons and discounts can be applied manually on a case-by-case
  basis, or you can associate them with certain plans to apply them
  automatically to new subscriptions. When creating a subscription,
  it will automatically inherit any add-ons and/or discounts
  associated with the plan. You can override those details at the
  time you create or update the subscription.
  """

  use Braintree.Construction

  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

  @type t :: %__MODULE__{
               id:                       String.t,
               amount:                   String.t,
               current_billing_cycle:    pos_integer,
               description:              String.t,
               kind:                     String.t,
               name:                     String.t,
               never_expires?:           boolean,
               number_of_billing_cycles: pos_integer,
               quantity:                 pos_integer
             }

  defstruct id:                       nil,
            amount:                   nil,
            current_billing_cycle:    nil,
            description:              nil,
            kind:                     nil,
            name:                     nil,
            never_expires?:           false,
            number_of_billing_cycles: 0,
            quantity:                 nil

  @doc """
  Returns a collection of Braintree::Discount objects.

  ## Example

      {:ok, discounts} = Braintree.Discount.all()
  """
  @spec all(Keyword.t) :: {:ok, t} | {:error, Error.t}
  def all(opts \\ []) do
    with {:ok, payload} <- HTTP.get("discounts", opts) do
      %{"discounts" => discounts} = payload

      {:ok, new(discounts)}
    end
  end
end
