defmodule Braintree.ACHDebit do
  @moduledoc """
  Struct for handling an ACH payment response from Braintree
  """

  use Braintree.Construction

  @type t :: %__MODULE__{
          account_holder_name: String.t(),
          account_type: String.t(),
          bank_name: String.t(),
          customer_id: String.t(),
          routing_number: String.t(),
          last_4: String.t(),
          token: String.t(),
          verified: boolean(),
        }

  defstruct account_holder_name: nil,
            account_type: nil,
            bank_name: nil,
            customer_id: nil,
            routing_number: nil,
            last_4: nil,
            token: nil,
            verified: nil
end
