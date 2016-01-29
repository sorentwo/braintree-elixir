defmodule Braintree.XML do
  @doctype ~s|<?xml version="1.0" encoding="UTF-8" ?>|

  @type xml :: binary

  import Braintree.Util, only: [hyphenate: 1, underscorize: 1]

  @spec dump(Map.t) :: xml
  def dump(map) do
    generate([@doctype|Enum.into(map, [])])
  end

  @spec load(xml) :: Map.t
  def load(xml) do
    root = xml |> Quinn.parse |> Enum.at(0)

    %{underscorize(root.name) => parse(root.value)}
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
