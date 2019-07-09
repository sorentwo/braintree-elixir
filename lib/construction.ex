defmodule Braintree.Construction do
  @moduledoc """
  This module provides a `use` macro to help convert raw HTTP responses into
  structs.
  """

  import Braintree.Util, only: [atomize: 1]

  defmacro __using__(_) do
    quote do
      alias Braintree.Construction

      def new(params) when is_map(params) or is_list(params) do
        Construction.new(__MODULE__, params)
      end

      defoverridable new: 1
    end
  end

  @doc """
  Convert a response into one or more typed structs.
  """
  @spec new(module(), map() | [map()]) :: struct() | [struct()]
  def new(module, params) when is_list(params) do
    Enum.map(params, &new(module, &1))
  end

  def new(module, params) when is_map(params) do
    struct(module, atomize(params))
  end
end
