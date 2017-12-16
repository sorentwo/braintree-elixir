defmodule Braintree.Construction do
  @moduledoc """
  This module provides a `use` macro to help convert raw HTTP responses into
  structs.
  """

  defmacro __using__(_) do
    quote do
      import Braintree.Util, only: [atomize: 1]

      @doc """
      Convert a response into one or more typed structs.
      """
      @spec new(map | [map]) :: t | [t]
      def new(params) when is_map(params) do
        struct(__MODULE__, atomize(params))
      end
      def new(params) when is_list(params) do
        Enum.map(params, &new/1)
      end

      defoverridable [new: 1]
    end
  end
end
