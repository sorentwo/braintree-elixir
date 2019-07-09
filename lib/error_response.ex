defmodule Braintree.ErrorResponse do
  @moduledoc """
  A general purpose response wrapper that is built for any failed API
  response.

  See the following pages for details about the various processor responses:

  * https://developers.braintreepayments.com/reference/general/processor-responses/authorization-responses
  * https://developers.braintreepayments.com/reference/general/processor-responses/settlement-responses
  * https://developers.braintreepayments.com/reference/general/processor-responses/avs-cvv-responses
  """

  use Braintree.Construction

  @type t :: %__MODULE__{
          errors: map,
          message: String.t(),
          params: map,
          transaction: map
        }

  defstruct errors: %{},
            message: "",
            params: %{},
            transaction: %{}
end
