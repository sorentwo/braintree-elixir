defmodule Braintree.ErrorResponse do
  @moduledoc """
  A general purpose response wrapper that is built for any failed API
  response.
  """

  import Braintree.Util, only: [atomize: 1]

  @type t :: %__MODULE__{
               errors:  Map.t,
               message: String.t,
               params:  Map.t
             }

  defstruct errors: %{},
            message: "",
            params: %{}

  @spec construct(Map.t) :: t
  def construct(map) do
    struct(__MODULE__, atomize(map))
  end
end
