defmodule Braintree.Util do
  @spec underscorize(String.t | atom) :: String.t
  def underscorize(value) when is_atom(value),
    do: underscorize(Atom.to_string(value))

  def underscorize(value) when is_binary(value),
    do: String.replace(value, "-", "_")

  def hyphenate(value) when is_atom(value),
    do: value |> to_string |> hyphenate

  def hyphenate(value) when is_binary(value),
    do: String.replace(value, "_", "-")
end
