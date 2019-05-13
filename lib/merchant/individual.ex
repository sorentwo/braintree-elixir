defmodule Braintree.Merchant.Individual do
  @moduledoc """
  Represents the individual section of a merchant account.

  For additional reference, see:
  https://developers.braintreepayments.com/reference/response/merchant-account/ruby
  """

  use Braintree.Construction

  alias Braintree.Address

  @type t :: %__MODULE__{
          address: Address.t(),
          first_name: String.t(),
          last_name: String.t(),
          email: String.t(),
          phone: String.t(),
          date_of_birth: String.t(),
          ssn_last_4: String.t()
        }

  defstruct address: %Address{},
            first_name: nil,
            last_name: nil,
            email: nil,
            phone: nil,
            date_of_birth: nil,
            ssn_last_4: nil
end
