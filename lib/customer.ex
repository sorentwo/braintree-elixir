defmodule Braintree.Customer do
  use Braintree.HTTP

  import Braintree.Util, only: [atomize: 1]

  @type timestamp :: {{integer, integer, integer}, {integer, integer, integer}}

  @type t :: %__MODULE__{
               id:                String.t,
               company:           String.t,
               email:             String.t,
               fax:               String.t,
               first_name:        String.t,
               last_name:         String.t,
               phone:             String.t,
               website:           String.t,
               created_at:        timestamp,
               updated_at:        timestamp,
               addresses:         [],
               credit_cards:      [],
               custom_fields:     %{},
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
            addresses:         [],
            credit_cards:      [],
            custom_fields:     %{},
            paypal_accounts:   [],
            coinbase_accounts: []

  @spec create(Map.t) :: {:ok, t} | {:error, t}
  def create(params \\ %{}) do
    case post("customers", %{customer: params}) do
      {:ok, %{"customer" => customer}} -> {:ok, structize(customer)}
      {:error, something} -> {:error, something}
    end
  end

  def structize(map), do: struct(__MODULE__, atomize(map))
end
