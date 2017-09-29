defmodule Braintree.MerchantAccount do
  @moduledoc """
  Represents a merchant account in a marketplace.

  For additional reference, see:
  https://developers.braintreepayments.com/reference/response/merchant-account/ruby
  """

  use Braintree.Construction

  alias Braintree.Merchant.{Individual, Business, Funding}

  @type t :: %__MODULE__{
    individual_details: Individual.t,
    business_details: Business.t,
    funding_details: Funding.t,
    id: String.t,
    master_merchant_account: String.t,
    status: String.t,
    currency_iso_code: String.t,
    default: boolean
  }

  defstruct individual_details: %Individual{},
            business_details: %Business{},
            funding_details: %Funding{},
            id: nil,
            master_merchant_account: nil,
            status: nil,
            currency_iso_code: nil,
            default: nil
end
