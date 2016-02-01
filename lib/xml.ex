defmodule Braintree.XML do
  @moduledoc """
  Simplified XML handling module that only supports `dump` and `load`.
  """

  @doctype ~s|<?xml version="1.0" encoding="UTF-8" ?>|

  @type xml :: binary

  import Braintree.Util, only: [hyphenate: 1, underscorize: 1]

  @doc ~S"""
  Converts a map into the equivalent XML representation.

  ## Examples

      iex> Braintree.XML.dump(%{a: %{b: 1, c: 2}})
      ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<a>\n<b>1</b>\n<c>2</c>\n</a>|
  """
  @spec dump(Map.t) :: xml
  def dump(map) do
    generate([@doctype | Enum.into(map, [])])
  end

  @doc ~S"""
  Converts an XML document, or fragment, into a map. Type annotation
  attributes are respected, but all other attributes are ignored.

  ## Examples

      iex> Braintree.XML.load("<a><b type='integer'>1</b><c>2</c></a>")
      %{"a" => %{"b" => 1, "c" => "2"}}
  """
  @spec load(xml) :: Map.t
  def load(xml) do
    %{name: name, value: value} = xml |> Quinn.parse |> Enum.at(0)

    %{underscorize(name) => parse(value)}
  end

  defp generate(term) when is_binary(term),
    do: term

  defp generate(term) when is_map(term),
    do: term |> Enum.into([]) |> generate

  defp generate(term) when is_list(term),
    do: term |> Enum.map(&generate/1) |> Enum.intersperse("\n") |> Enum.join

  defp generate({name, value}) when is_map(value),
    do: "<#{hyphenate(name)}>\n#{generate(value)}\n</#{hyphenate(name)}>"

  defp generate({name, value}) when is_list(value),
    do: generate({name, "\n#{generate(value)}\n"})

  defp generate({name, value}),
    do: "<#{hyphenate(name)}>#{value}</#{hyphenate(name)}>"

  defp parse(elements) when is_list(elements),
    do: for element <- elements, into: %{}, do: parse(element)

  defp parse(%{name: name, attr: [type: "integer"], value: [value]}),
    do: {underscorize(name), String.to_integer(value)}

  defp parse(%{name: name, attr: [type: "array"], value: elements}),
    do: {underscorize(name), Enum.map(elements, &parse(&1.value))}

  defp parse(%{name: name, attr: [type: "datetime"], value: [value]}),
    do: {underscorize(name), value}

  defp parse(%{name: name, attr: [nil: "true"], value: []}),
    do: {underscorize(name), nil}

  defp parse(%{name: name, value: [value]}),
    do: {underscorize(name), value}

  defp parse(%{name: name, value: []}),
    do: {underscorize(name), ""}

  defp parse(%{name: name, value: values}) do
    values = for element <- values, into: %{}, do: {name, parse(element)}

    {underscorize(name), values}
  end
end
