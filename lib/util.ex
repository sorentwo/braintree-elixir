defmodule Braintree.Util do
  @moduledoc """
  General purpose utility functions.
  """

  @doc """
  Converts hyphenated values to underscore delimited strings.

  ## Examples

      iex> Braintree.Util.underscorize("brain-tree")
      "brain_tree"

      iex> Braintree.Util.underscorize(:"brain-tree")
      "brain_tree"
  """
  @spec underscorize(String.t() | atom) :: String.t()
  def underscorize(value) when is_atom(value), do: underscorize(Atom.to_string(value))

  def underscorize(value) when is_binary(value), do: String.replace(value, "-", "_")

  @doc """
  Converts underscored values to hyphenated strings.

  ## Examples

      iex> Braintree.Util.hyphenate("brain_tree")
      "brain-tree"

      iex> Braintree.Util.hyphenate(:brain_tree)
      "brain-tree"
  """
  @spec hyphenate(String.t() | atom) :: String.t()
  def hyphenate(value) when is_atom(value), do: value |> to_string() |> hyphenate()

  def hyphenate(value) when is_binary(value), do: String.replace(value, "_", "-")

  @doc """
  Recursively convert a map of string keys into a map with atom keys. Intended
  to prepare responses for conversion into structs. Note that it converts any
  string into an atom, whether it existed or not.

  For unknown maps with unknown keys this is potentially dangerous, but should
  be fine when used with known Braintree endpoints.

  ## Example

      iex> Braintree.Util.atomize(%{"a" => 1, "b" => %{"c" => 2}})
      %{a: 1, b: %{c: 2}}
  """
  @spec atomize(map) :: map
  def atomize(map) when is_map(map) do
    Enum.into(map, %{}, fn
      {key, val} when is_map(val) -> {String.to_atom(key), atomize(val)}
      {key, val} -> {String.to_atom(key), val}
    end)
  end
end
