defmodule Braintree.Util do
  @spec underscorize(String.t | atom) :: String.t
  def underscorize(value) when is_atom(value),
    do: underscorize(Atom.to_string(value))

  def underscorize(value) when is_binary(value),
    do: String.replace(value, "-", "_")

  @spec hyphenate(String.t | atom) :: String.t
  def hyphenate(value) when is_atom(value),
    do: value |> to_string |> hyphenate

  def hyphenate(value) when is_binary(value),
    do: String.replace(value, "_", "-")

  @spec atomize(Map.t) :: Map.t
  def atomize(map) when is_map(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end
end
