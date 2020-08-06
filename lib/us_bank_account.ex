defmodule Braintree.UsBankAccount do
  @moduledoc """
  UsBankAccount structs are not created directly, but are built within
  responses from other endpoints, such as `Braintree.Customer`.
  """

  use Braintree.Construction

  @type t :: %__MODULE__{
          account_number: String.t(),
          account_type: String.t(),
          ach_mandate: map(),
          bank_name: String.t(),
          business_name: String.t(),
          customer_id: String.t(),
          customer_global_id: String.t(),
          account_holder_name: String.t(),
          default: String.t(),
          first_name: String.t(),
          global_id: String.t(),
          image_url: String.t(),
          last_4: String.t(),
          last_name: String.t(),
          ownership_type: String.t(),
          routing_number: String.t(),
          token: String.t(),
          vaulted_in_blue: String.t(),
          verifications: [any],
          verified: boolean,
          verified_by: String.t(),
          created_at: String.t(),
          updated_at: String.t()
        }

  defstruct account_number: nil,
            account_type: nil,
            ach_mandate: nil,
            bank_name: nil,
            business_name: nil,
            customer_id: nil,
            customer_global_id: nil,
            account_holder_name: nil,
            default: nil,
            first_name: nil,
            global_id: nil,
            image_url: nil,
            last_4: nil,
            last_name: nil,
            ownership_type: nil,
            routing_number: nil,
            token: nil,
            vaulted_in_blue: nil,
            verifications: [],
            verified: nil,
            verified_by: nil,
            created_at: nil,
            updated_at: nil
end
