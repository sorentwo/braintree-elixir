defmodule Braintree.Merchant.Business do
  @moduledoc """
  Represents the business section of a merchant account.

  For additional reference, see:
  https://developers.braintreepayments.com/reference/response/merchant-account/ruby
  """

  use Braintree.Construction

  alias Braintree.Address

  @type t :: %__MODULE__{
    address: Address.t,
    legal_name: String.t,
    dba_name: String.t,
    tax_id: String.t
  }

  defstruct address: %Address{},
            legal_name: nil,
            dba_name: nil,
            tax_id: nil
end
