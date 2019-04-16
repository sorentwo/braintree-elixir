defmodule Braintree.Address do
  @moduledoc """
  You can create an address for a customer only although the structure
  is also used for a merchant account.

  For additional reference see:
  https://developers.braintreepayments.com/reference/request/address/create/ruby
  """

  use Braintree.Construction

  alias Braintree.ErrorResponse, as: Error
  alias Braintree.HTTP

  @type t :: %__MODULE__{
          id: String.t(),
          company: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          first_name: String.t(),
          last_name: String.t(),
          locality: String.t(),
          postal_code: String.t(),
          region: String.t(),
          street_address: String.t(),
          country_code_alpha2: String.t(),
          country_code_alpha3: String.t(),
          country_code_numeric: String.t(),
          country_name: String.t(),
          customer_id: String.t(),
          extended_address: String.t()
        }

  defstruct id: nil,
            company: nil,
            created_at: nil,
            updated_at: nil,
            first_name: nil,
            last_name: nil,
            locality: nil,
            postal_code: nil,
            region: nil,
            street_address: nil,
            country_code_alpha2: nil,
            country_code_alpha3: nil,
            country_code_numeric: nil,
            country_name: nil,
            customer_id: nil,
            extended_address: nil

  @doc """
  Create an address record, or return an error response after failed validation.

  ## Example

    {:ok, address} = Braintree.Address.create("customer_id", %{
      first_name: "Jenna"
    })

    address.company # Braintree
  """
  @spec create(binary, map, Keyword.t()) ::
          {:ok, t} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def create(customer_id, params \\ %{}, opts \\ []) when is_binary(customer_id) do
    with {:ok, payload} <-
           HTTP.post("customers/#{customer_id}/addresses/", %{address: params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  You can delete an address using its customer ID and address ID.

  ## Example

      :ok = Braintree.Address.delete("customer_id", "address_id")
  """
  @spec delete(binary, binary, Keyword.t()) ::
          :ok | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def delete(customer_id, id, opts \\ []) when is_binary(customer_id) and is_binary(id) do
    with {:ok, _reponse} <- HTTP.delete("customers/#{customer_id}/addresses/" <> id, opts) do
      :ok
    end
  end

  @doc """
  To update an address, use a customer's ID with an address's ID along with
  new attributes. The same validations apply as when creating an address.
  Any attribute not passed will remain unchanged.

  ## Example

      {:ok, address} = Braintree.Address.update("customer_id", "address_id", %{
        company: "New Company Name"
      })

      address.company # "New Company Name"
  """
  @spec update(binary, binary, map, Keyword.t()) ::
          {:ok, t} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def update(customer_id, id, params, opts \\ []) when is_binary(customer_id) and is_binary(id) do
    with {:ok, payload} <-
           HTTP.put("customers/#{customer_id}/addresses/" <> id, %{address: params}, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  If you want to look up a single address for a customer using the customer ID and
  the address ID, use the find method.

  ## Example

    address = Braintree.Address.find("customer_id", "address_id")
  """
  @spec find(binary, binary, Keyword.t()) ::
          {:ok, t} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def find(customer_id, id, opts \\ []) when is_binary(customer_id) and is_binary(id) do
    with {:ok, payload} <- HTTP.get("customers/#{customer_id}/addresses/" <> id, opts) do
      {:ok, new(payload)}
    end
  end

  @doc """
  Convert a map into a Address struct.

  ## Example

      address = Braintree.Address.new(%{"company" => "Braintree"})
  """
  def new(%{"address" => map}), do: super(map)
end
