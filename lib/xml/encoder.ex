defmodule Braintree.XML.Encoder do
  @moduledoc """
  XML encoding tailored to dumping Braintree compatible params.
  """

  @type xml :: binary

  import Braintree.Util, only: [hyphenate: 1]
  import Braintree.XML.Entity, only: [encode: 1]

  @doctype ~s|<?xml version="1.0" encoding="UTF-8" ?>\n|

  @doc ~S"""
  Converts a map into the equivalent XML representation.

  ## Examples

      iex> Braintree.XML.Encoder.dump(%{a: %{b: 1, c: 2}})
      ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<a>\n<b>1</b>\n<c>2</c>\n</a>|

      iex> Braintree.XML.Encoder.dump(%{a: %{b: "<tag>"}})
      ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<a>\n<b>&lt;tag&gt;</b>\n</a>|
  """
  @spec dump(map) :: xml
  def dump(map) do
    generated =
      map
      |> escape_entity
      |> generate

    @doctype <> generated
  end

  defp generate(term) when is_map(term),
    do: term |> Map.to_list() |> Enum.map_join("\n", &generate/1)

  defp generate(term) when is_list(term),
    do: term |> Enum.map_join("\n", fn item -> "<item>\n#{generate(item)}\n</item>" end)

  defp generate(value) when is_binary(value), do: value

  defp generate({name, value}) when is_map(value),
    do: "<#{hyphenate(name)}>\n#{generate(value)}\n</#{hyphenate(name)}>"

  defp generate({name, value}) when is_list(value),
    do: "<#{hyphenate(name)} type=\"array\">\n#{generate(value)}\n</#{hyphenate(name)}>"

  defp generate({name, value}), do: "<#{hyphenate(name)}>#{value}</#{hyphenate(name)}>"

  defp escape_entity(entity) when is_map(entity),
    do: for({key, value} <- entity, into: %{}, do: {key, escape_entity(value)})

  defp escape_entity(entity) when is_list(entity),
    do: for(value <- entity, do: escape_entity(value))

  defp escape_entity(entity) when is_binary(entity), do: encode(entity)

  defp escape_entity(entity), do: entity
end
