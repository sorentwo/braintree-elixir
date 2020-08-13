defmodule Braintree.ApplePayCard do
  @moduledoc """
  ApplePayCard structs are not created directly, but are built within
  responsees from other endpoints, such as `Braintree.Customer`.
  """

  use Braintree.Construction
  alias Braintree.Address

  @type t :: %__MODULE__{
          billing_address: Address.t(),
          bin: String.t(),
          card_type: String.t(),
          cardholder_name: String.t(),
          created_at: String.t(),
          customer_global_id: String.t(),
          customer_id: String.t(),
          default: String.t(),
          expiration_month: String.t(),
          expiration_year: String.t(),
          expired: String.t(),
          global_id: String.t(),
          image_url: String.t(),
          last_4: String.t(),
          payment_instrument_name: String.t(),
          source_description: String.t(),
          subscriptions: [any],
          token: String.t(),
          updated_at: String.t()
        }

  defstruct billing_address: nil,
            bin: nil,
            card_type: nil,
            cardholder_name: nil,
            created_at: nil,
            customer_global_id: nil,
            customer_id: nil,
            default: false,
            expiration_month: nil,
            expiration_year: nil,
            expired: nil,
            global_id: nil,
            image_url: nil,
            last_4: nil,
            payment_instrument_name: nil,
            source_description: nil,
            subscriptions: [],
            token: nil,
            updated_at: nil
end
