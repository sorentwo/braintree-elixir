defmodule Braintree.ErrorResponse do
  @moduledoc """
  A general purpose response wrapper that is built for any failed API
  response.
  """

  use Braintree.Construction

  @type t :: %__MODULE__{
               errors:  Map.t,
               message: String.t,
               params:  Map.t
             }

  defstruct errors: %{},
            message: "",
            params: %{}
end
