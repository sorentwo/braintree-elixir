defmodule Braintree.SettlementBatchSummary do
  @moduledoc """
  The settlement batch summary displays the total sales and credits for each
  batch for a particular date. The transactions can be grouped by a single
  custom field's values.

  https://developers.braintreepayments.com/reference/request/settlement-batch-summary/generate/ruby
  """

  use Braintree.Construction

  import Braintree.Util, only: [atomize: 1]

  alias Braintree.ErrorResponse, as: Error
  alias Braintree.HTTP

  defmodule Record do
    @moduledoc """
    A record contains details for a transaction in a summary.
    """

    @type t :: %__MODULE__{
            card_type: String.t(),
            count: String.t(),
            merchant_account_id: String.t(),
            kind: String.t(),
            amount_settled: String.t()
          }

    defstruct card_type: nil,
              count: "0",
              merchant_account_id: nil,
              kind: nil,
              amount_settled: nil

    @doc """
    Convert a list of records into structs, including any custom fields that
    were used as the grouping value.
    """
    def new(params) when is_map(params) do
      atomized = atomize(params)
      summary = Construction.new(__MODULE__, params)

      case Map.keys(atomized) -- Map.keys(summary) do
        [custom_key] -> Map.put(summary, custom_key, atomized[custom_key])
        _ -> summary
      end
    end

    def new(params) when is_list(params) do
      Enum.map(params, &new/1)
    end
  end

  @type t :: %__MODULE__{records: [Record.t()]}

  defstruct records: []

  @doc """
  Generate a report of all settlements for a particular date. The
  field used for custom grouping will always be set as
  `custom_field`, regardless of its name.

  ## Example

      Braintree.SettlementBatchSummary("2016-9-5", "custom_field_1")
  """
  @spec generate(binary, binary | nil, Keyword.t()) :: {:ok, [t]} | {:error, Error.t()} | {:error, atom()} | {:error, binary()}
  def generate(settlement_date, custom_field \\ nil, opts \\ []) do
    criteria = build_criteria(settlement_date, custom_field)
    params = %{settlement_batch_summary: criteria}

    with {:ok, payload} <- HTTP.post("settlement_batch_summary", params, opts) do
      %{"settlement_batch_summary" => summary} = payload

      {:ok, new(summary)}
    end
  end

  @spec build_criteria(binary, binary | nil) :: map
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
  def new(%{"records" => records}) do
    struct(__MODULE__, records: Record.new(records))
  end
end
