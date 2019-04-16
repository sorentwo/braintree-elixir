defmodule Braintree.Merchant.Account do
  @moduledoc """
  Represents a merchant account in a marketplace.

  For additional reference, see:
  https://developers.braintreepayments.com/reference/response/merchant-account/ruby
  """

  use Braintree.Construction

  alias Braintree.ErrorResponse, as: Error
  alias Braintree.HTTP
  alias Braintree.Merchant.{Business, Funding, Individual}

  @type t :: %__MODULE__{
          individual: Individual.t(),
          business: Business.t(),
          funding: Funding.t(),
          id: String.t(),
          master_merchant_account: String.t(),
          status: String.t(),
          currency_iso_code: String.t(),
          default: boolean
        }

  defstruct individual: %Individual{},
            business: %Business{},
            funding: %Funding{},
            id: nil,
            master_merchant_account: nil,
            status: nil,
            currency_iso_code: nil,
            default: false

  @doc """
  Create a merchant account or return an error response after failed validation

  ## Example

    {:ok, merchant} = Braintree.Merchant.Account.create(%{
      tos_accepted: true,
    })
  """
  @spec create(map, Keyword.t()) ::
          {:ok, t} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def create(params \\ %{}, opts \\ []) do
    with {:ok, payload} <-
           HTTP.post("merchant_accounts/create_via_api", %{merchant_account: params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  To update a merchant, use its ID along with new attributes.
  The same validations apply as when creating a merchant.
  Any attribute not passed will remain unchanged.

  ## Example

      {:ok, merchant} = Braintree.Merchant.update("merchant_id", %{
        funding_details: %{account_number: "1234567890"}
      })

      merchant.funding_details.account_number # "1234567890"
  """
  @spec update(binary, map, Keyword.t()) ::
          {:ok, t} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def update(id, params, opts \\ []) when is_binary(id) do
    with {:ok, payload} <-
           HTTP.put("merchant_accounts/#{id}/update_via_api", %{merchant_account: params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  If you want to look up a single merchant using ID, use the find method.

  ## Example

    merchant = Braintree.Merchant.find("merchant_id")
  """
  @spec find(binary, Keyword.t()) ::
          {:ok, t} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def find(id, opts \\ []) when is_binary(id) do
    with {:ok, payload} <- HTTP.get("merchant_accounts/" <> id, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Convert a map into a `Braintree.Merchant.Account` struct.
  """
  def new(%{"merchant_account" => map}), do: super(map)
end
