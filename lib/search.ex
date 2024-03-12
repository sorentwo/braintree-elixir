defmodule Braintree.Search do
  @moduledoc """
  This module performs advanced search on a resource.

  For additional reference see:
  https://developers.braintreepayments.com/reference/general/searching/search-fields/ruby
  """

  alias Braintree.HTTP

  @doc """
  Perform an advanced search on a given resource and create new structs
  based on the initializer given.

  ## Example
    search_params = %{first_name: %{is: "Jenna"}}
    {:ok, customers} = Braintree.Search.perform(search_params, "customers", &Braintree.Customer.new/1)

  """
  @spec perform(map, String.t(), fun(), Keyword.t()) :: {:ok, [any]} | HTTP.error()
  def perform(params, resource, initializer, opts \\ []) when is_map(params) do
    with {:ok, payload} <- HTTP.post(resource <> "/advanced_search_ids", %{search: params}, opts) do
      fetch_all_records(payload, resource, initializer, opts)
    end
  end

  defp fetch_all_records(%{"search_results" => %{"ids" => []}}, _resource, _initializer, _opts) do
    {:error, :not_found}
  end

  defp fetch_all_records(
         %{"search_results" => %{"page_size" => page_size, "ids" => ids}},
         resource,
         initializer,
         opts
       ) do
    records =
      ids
      |> Enum.chunk_every(page_size)
      |> Enum.flat_map(fn ids_chunk ->
        fetch_records_chunk(ids_chunk, resource, initializer, opts)
      end)

    {:ok, records}
  end

  # Credit card verifications and transactions are an odd case because path to endpoints is
  # different from the object name in the XML.
  defp fetch_records_chunk(ids, resource, initializer, opts)
       when is_list(ids) and resource in ~w(verifications transactions) do
    search_params = %{search: %{ids: ids}}
    key_name = "credit_card_#{resource}"

    with {:ok, %{^key_name => data}} <-
           HTTP.post(resource <> "/advanced_search", search_params, opts) do
      initializer.(data)
    end
  end

  defp fetch_records_chunk(ids, resource, initializer, opts) when is_list(ids) do
    search_params = %{search: %{ids: ids}}

    with {:ok, %{^resource => data}} <-
           HTTP.post(resource <> "/advanced_search", search_params, opts) do
      initializer.(data)
    end
  end
end
