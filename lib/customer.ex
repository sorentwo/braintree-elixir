defmodule Braintree.Customer do
  use Braintree.HTTP

  import Braintree.Util, only: [atomize: 1]

  alias Braintree.CreditCard
  alias Braintree.ErrorResponse, as: Error

  @type t :: %__MODULE__{
               id:                String.t,
               company:           String.t,
               email:             String.t,
               fax:               String.t,
               first_name:        String.t,
               last_name:         String.t,
               phone:             String.t,
               website:           String.t,
               created_at:        String.t,
               updated_at:        String.t,
               custom_fields:     %{},
               addresses:         [],
               credit_cards:      [],
               paypal_accounts:   [],
               coinbase_accounts: []
             }

  defstruct id:                nil,
            company:           nil,
            email:             nil,
            fax:               nil,
            first_name:        nil,
            last_name:         nil,
            phone:             nil,
            website:           nil,
            created_at:        nil,
            updated_at:        nil,
            custom_fields:     %{},
            addresses:         [],
            credit_cards:      [],
            coinbase_accounts: [],
            paypal_accounts:   []

  @spec create(Map.t) :: {:ok, t} | {:error, Error.t}
  def create(params \\ %{}) do
    case post("customers", %{customer: params}) do
      {:ok, %{"customer" => customer}} ->
        {:ok, construct(customer)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end

  @doc false
  def construct(map) do
    company = struct(__MODULE__, atomize(map))

    %{company | credit_cards: construct_many(CreditCard, company.credit_cards)}
  end

  defp construct_many(module, props) do
    Enum.map(props, &(struct(module, atomize(&1))))
  end
end
