defmodule Braintree.Search do
  alias Braintree.{HTTP}

  @doc """
  Perform an advanced search on a given resource and create new structs
  based on the initializer given.
  """

  def perform(params, resource, initializer, opts \\ []) when is_map(params) do
    with {:ok, payload} <- HTTP.post(resource <> "/advanced_search_ids", %{search: params}, opts) do
      ids(payload, resource, initializer, opts)
    end
  end

  defp ids(payload, resource, initializer, opts) when is_map(payload) do
    search_results = Map.get(payload, "search_results")
    page_size      = Map.get(search_results, "page_size")
    ids            = Map.get(search_results, "ids")

    fetch_all_ids(ids, page_size, resource, initializer, opts)
  end

  defp fetch_all_ids([], _page_size, _resource, _initializer, _opts),
    do: {:error, :not_found}
  defp fetch_all_ids(ids, page_size, resource, initializer, opts) do
    {:ok, Enum.chunk_every(ids, page_size)
          |> Enum.reduce([], fn ids_chunk, acc ->
            acc ++ [fetch_ids_chunk(ids_chunk, resource, initializer, opts)]
          end)
          |> List.flatten}
  end

  defp fetch_ids_chunk(ids, "verifications"=resource, initializer, opts) when is_list(ids) do
    search_params = %{search: %{ids: ids}}
    with {:ok, %{"credit_card_verifications" => data}} <- HTTP.post(resource <> "/advanced_search", search_params, opts) do
      initializer.(data)
    end
  end

  defp fetch_ids_chunk(ids, resource, initializer, opts) when is_list(ids) do
    search_params = %{search: %{ids: ids}}
    with {:ok, %{^resource => data}} <- HTTP.post(resource <> "/advanced_search", search_params, opts) do
      initializer.(data)
    end
  end
end
