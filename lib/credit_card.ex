defmodule Braintree.CreditCard do
  @moduledoc """
  CreditCard structs are not created directly, but are built within
  responsees from other endpoints, such as `Braintree.Customer`.
  """

  import Braintree.Util, only: [atomize: 1]

  @type t :: %__MODULE__{
               bin:                      String.t,
               card_type:                String.t,
               cardholder_name:          String.t,
               commercial:               String.t,
               country_of_issuance:      String.t,
               customer_id:              String.t,
               customer_location:        String.t,
               debit:                    String.t,
               default:                  String.t,
               durbin_regulated:         String.t,
               expiration_month:         String.t,
               expiration_year:          String.t,
               expired:                  String.t,
               healthcare:               String.t,
               image_url:                String.t,
               issuing_bank:             String.t,
               last_4:                   String.t,
               payroll:                  String.t,
               prepaid:                  String.t,
               token:                    String.t,
               unique_number_identifier: String.t,
               created_at:               String.t,
               updated_at:               String.t,
               venmo_sdk:                boolean,
               subscriptions:            [],
               verifications:            []
             }

  defstruct bin:                      nil,
            card_type:                nil,
            cardholder_name:          nil,
            commercial:               "Unknown",
            country_of_issuance:      "Unknown",
            customer_id:              nil,
            customer_location:        nil,
            debit:                    "Unknown",
            default:                  false,
            durbin_regulated:         "Unknown",
            expiration_month:         nil,
            expiration_year:          nil,
            expired:                  nil,
            healthcare:               "Unknown",
            image_url:                nil,
            issuing_bank:             "Unknown",
            last_4:                   nil,
            payroll:                  "Unknown",
            prepaid:                  "Unknown",
            token:                    nil,
            unique_number_identifier: nil,
            created_at:               nil,
            updated_at:               nil,
            venmo_sdk:                "Unknown",
            subscriptions:            [],
            verifications:            []

  @spec construct(Map.t) :: t
  def construct(map) do
    struct(__MODULE__, atomize(map))
  end
end
