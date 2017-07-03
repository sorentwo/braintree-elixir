defmodule Braintree.SettlementBatchSummary do
  @moduledoc """
  The settlement batch summary displays the total sales and credits for each
  batch for a particular date. The transactions can be grouped by a single
  custom field's values.

  https://developers.braintreepayments.com/reference/request/settlement-batch-summary/generate/ruby
  """

  use Braintree.Construction

  alias Braintree.HTTP
  alias Braintree.ErrorResponse, as: Error

  defmodule Record do
    @moduledoc """
    A record contains details for a transaction in a summary.
    """

    @type t :: %__MODULE__{
                 card_type:           String.t,
                 count:               String.t,
                 merchant_account_id: String.t,
                 kind:                String.t,
                 amount_settled:      String.t
               }

    defstruct card_type:           nil,
              count:               "0",
              merchant_account_id: nil,
              kind:                nil,
              amount_settled:      nil

    @doc """
    Convert a list of records into structs, including any custom fields that
    were used as the grouping value.
    """
    def construct(params) when is_map(params) do
      atomized = atomize(params)
      summary = struct(__MODULE__, atomized)

      case Map.keys(atomized) -- Map.keys(summary) do
        [custom_key] -> Map.put(summary, custom_key, atomized[custom_key])
                   _ -> summary
      end
    end
    def construct(params) when is_list(params) do
      Enum.map(params, &construct/1)
    end
  end

  @type t :: %__MODULE__{records: [Record.t]}

  defstruct records: []

  @doc """
  Generate a report of all settlements for a particular date. The
  field used for custom grouping will always be set as
  `custom_field`, regardless of its name.

  ## Example

      Braintree.SettlementBatchSummary("2016-9-5", "custom_field_1")
  """
  @spec generate(binary, binary | nil) :: {:ok, [t]} | {:error, Error.t}
  def generate(settlement_date, custom_field \\ nil) do
    criteria = build_criteria(settlement_date, custom_field)

    case HTTP.post("settlement_batch_summary", %{settlement_batch_summary: criteria}) do
      {:ok, %{"settlement_batch_summary" => summary}} ->
        {:ok, construct(summary)}
      {:error, %{"api_error_response" => error}} ->
        {:error, Error.construct(error)}
    end
  end

  @spec build_criteria(binary, binary | nil) :: Map.t
  defp build_criteria(settlement_date, nil) do
    %{settlement_date: settlement_date}
  end
  defp build_criteria(settlement_date, custom_field) do
    %{settlement_date: settlement_date, group_by_custom_field: custom_field}
  end

  @doc """
  Convert a map including records into a summary struct with a list
  of record structs.
  """
  @spec construct(Map.t) :: t
  def construct(map) when is_map(map) do
    records = Record.construct(Map.get(map, "records"))

    struct(__MODULE__, records: records)
  end
end
