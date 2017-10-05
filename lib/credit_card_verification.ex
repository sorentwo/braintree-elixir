defmodule Braintree.CreditCardVerification do
  @moduledoc """
  Manage credit card verifications.

  For additional reference see:
  https://developers.braintreepayments.com/reference/response/credit-card-verification/ruby
  """

  use Braintree.Construction

  alias Braintree.{HTTP, Address, CreditCard, Search}
  alias Braintree.ErrorResponse, as: Error

  @type t :: %__MODULE__{
                amount:                             Decimal.t,
                avs_error_response_code:            String.t,
                avs_postal_code_response_code:      String.t,
                avs_street_address_response_code:   String.t,
                billing:                            Address.t,
                created_at:                         String.t,
                credit_card:                        CreditCard.t,
                currency_iso_code:                  String.t,
                cvv_response_code:                  String.t,
                gateway_rejection_reason:           String.t,
                id:                                 String.t,
                merchant_account_id:                String.t,
                processor_response_code:            String.t,
                processor_response_text:            String.t,
                risk_data:                          %{},
                status:                             String.t
            }

  defstruct amount:                             nil,
            avs_error_response_code:            nil,
            avs_postal_code_response_code:      nil,
            avs_street_address_response_code:   nil,
            billing:                            %Address{},
            created_at:                         nil,
            credit_card:                        %CreditCard{},
            currency_iso_code:                  nil,
            cvv_response_code:                  nil,
            gateway_rejection_reason:           nil,
            id:                                 nil,
            merchant_account_id:                nil,
            processor_response_code:            nil,
            processor_response_text:            nil,
            risk_data:                          %{},
            status:                             nil

  @doc """
  To search for credit card verifications, pass a map of search parameters.

  ## Example:

    search_params = %{amount: %{min: "10.0", max: "15.0"},
                      status: ["approved", "pending"]}

    {:ok, verifications} = Braintree.CreditCardVerification.search(search_params)
  """
  @spec search(Map.t, Keyword.t) :: {:ok, t} | {:error, Error.t}
  def search(params, opts \\ []) when is_map(params) do
    Search.perform(params, "verifications", &new/1, opts)
  end

  @doc """
  Convert a map into a CreditCardVerification struct.

  ## Example

      verification = Braintree.CreditCardVerification.new(%{"credit_card_card_type" => "Visa"})
  """
  @spec new(Map.t | [Map.t]) :: t | [t]
  def new(%{"credit_card_verification" => map}) do
    new(map)
  end
  def new(map) when is_map(map) do
    super(map)
  end
  def new(list) when is_list(list) do
    Enum.map(list, &new/1)
  end
end
