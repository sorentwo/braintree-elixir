defmodule Braintree.Merchant.Funding do
  @moduledoc """
  Represents the funding section of a merchant account.

  For additional reference, see:
  https://developers.braintreepayments.com/reference/response/merchant-account/ruby
  """

  use Braintree.Construction

  @type t :: %__MODULE__{
    descriptor: String.t,
    destination: String.t,
    email: String.t,
    mobile_phone: String.t,
    routing_number: String.t,
    account_number_last_4: String.t
  }

  defstruct descriptor: nil,
            destination: nil,
            email: nil,
            mobile_phone: nil,
            routing_number: nil,
            account_number_last_4: nil
end
