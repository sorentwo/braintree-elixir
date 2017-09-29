defmodule Braintree.Merchant.Individual do
  @moduledoc """
  Represents the individual section of a merchant account.

  For additional reference, see:
  https://developers.braintreepayments.com/reference/response/merchant-account/ruby
  """

  use Braintree.Construction

  alias Braintree.Address

  @type t :: %__MODULE__{
    address_details: Address.t,
    first_name: String.t,
    last_name: String.t,
    email: String.t,
    phone: String.t,
    date_of_birth: String.t,
    ssn: String.t,
  }

  defstruct address_details: %Address{},
            first_name: nil,
            last_name: nil,
            email: nil,
            phone: nil,
            date_of_birth: nil,
            ssn: nil
end
