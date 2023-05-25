defmodule Braintree.VenmoAccount do
  @moduledoc """
  VenmoAccount structs are not created directly, but are built within
  responses from other endpoints, such as `Braintree.Customer`.
  """

  use Braintree.Construction

  @type t :: %__MODULE__{
          created_at: String.t(),
          customer_global_id: String.t(),
          customer_id: String.t(),
          default: String.t(),
          global_id: String.t(),
          image_url: String.t(),
          source_description: String.t(),
          token: String.t(),
          updated_at: String.t(),
          username: String.t(),
          venmo_user_id: String.t()
        }

  defstruct customer_global_id: nil,
            created_at: nil,
            customer_id: nil,
            default: nil,
            global_id: nil,
            image_url: nil,
            source_description: nil,
            token: nil,
            updated_at: nil,
            username: nil,
            venmo_user_id: nil
end
