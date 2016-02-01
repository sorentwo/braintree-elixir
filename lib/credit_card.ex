defmodule Braintree.CreditCard do

  @type timestamp :: {{integer, integer, integer}, {integer, integer, integer}}

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
               created_at:               timestamp,
               updated_at:               timestamp,
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

  defmodule Verification do
    @type t :: %__MODULE__{
                 avs_error_response_code:          String.t,
                 avs_postal_code_response_code:    String.t,
                 avs_street_address_response_code: String.t,
                 cvv_response_code:                String.t,
                 merchant_account_id:              String.t,
                 processor_response_code:          String.t,
                 processor_response_text:          String.t,
                 status:                           String.t,
                 id:                               String.t,
                 gateway_rejection_reason:         String.t,
                 credit_card:                      CreditCard.t,
                 billing:                          String.t,
                 risk_data:                        String.t,
                 created_at:                       String.t
              }

    defstruct [
      :avs_error_response_code,
      :avs_postal_code_response_code,
      :avs_street_address_response_code,
      :cvv_response_code,
      :merchant_account_id,
      :processor_response_code,
      :processor_response_text,
      :status,
      :id,
      :gateway_rejection_reason,
      :credit_card,
      :billing,
      :risk_data,
      :created_at
    ]
  end
end
