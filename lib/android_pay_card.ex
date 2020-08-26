defmodule Braintree.AndroidPayCard do
  @moduledoc """
  AndroidPayCard structs are not created directly, but are built within
  responsees from other endpoints, such as `Braintree.Customer`.
  """
  use Braintree.Construction

  @type t :: %__MODULE__{
          bin: String.t(),
          created_at: String.t(),
          customer_id: String.t(),
          default: boolean,
          expiration_month: String.t(),
          expiration_year: String.t(),
          google_transaction_id: String.t(),
          image_url: String.t(),
          is_network_tokenized: boolean,
          source_card_last_4: String.t(),
          source_card_type: String.t(),
          source_description: String.t(),
          subscriptions: [any],
          token: String.t(),
          updated_at: String.t(),
          virtual_card_last_4: String.t(),
          virtual_card_type: String.t()
        }

  defstruct bin: nil,
            billing_address: nil,
            created_at: nil,
            customer_id: nil,
            default: false,
            expiration_month: nil,
            expiration_year: nil,
            google_transaction_id: nil,
            image_url: nil,
            is_network_tokenized: false,
            source_card_last_4: nil,
            source_card_type: nil,
            source_description: nil,
            subscriptions: [],
            token: nil,
            updated_at: nil,
            virtual_card_last_4: nil,
            virtual_card_type: nil
end
