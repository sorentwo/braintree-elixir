defmodule Braintree.XML.Decoder do
  @moduledoc """
  XML dumping tailored to encoding params sent by Braintree.
  """

  @type xml :: binary()

  import Braintree.Util, only: [underscorize: 1]
  import Braintree.XML.Entity, only: [decode: 1]

  @doc ~S"""
  Converts an XML document, or fragment, into a map. Type annotation
  attributes are respected, but all other attributes are ignored.

  ## Examples

      iex> Braintree.XML.Decoder.load("<a><b type='integer'>1</b><c>2</c></a>")
      %{"a" => %{"b" => 1, "c" => "2"}}

      iex> Braintree.XML.Decoder.load("<a><b type='string'>Jos&#233;</b></a>")
      %{"a" => %{"b" => "José"}}

      iex> Braintree.XML.Decoder.load("<a><b type='string'>First &amp; Last</b></a>")
      %{"a" => %{"b" => "First & Last"}}

      iex> Braintree.XML.Decoder.load("<a><b type='string'>&quot;air quotes&quot;</b></a>")
      %{"a" => %{"b" => ~s("air quotes")}}
  """
  @spec load(xml) :: map()
  def load(""), do: %{}

  def load(xml) do
    {name, attributes, values} =
      xml
      |> decode()
      |> :erlang.bitstring_to_list()
      |> :xmerl_scan.string()
      |> elem(0)
      |> parse()

    case attributes do
      [type: "array"] -> %{name => transform({attributes, values})}
      [type: "collection"] -> %{name => transform({attributes, values})}
      _ -> %{name => transform(values)}
    end
  end

  defp parse(elements) when is_list(elements), do: Enum.map(elements, &parse/1)

  defp parse({:xmlElement, name, _, _, _, _, _, attributes, elements, _, _, _}),
    do: {underscorize(name), parse(attributes), parse(elements)}

  defp parse({:xmlAttribute, name, _, _, _, _, _, _, value, _}), do: {name, to_string(value)}

  defp parse({:xmlText, _, _, _, value, _}),
    do:
      value
      |> to_string()
      |> String.trim()
      |> List.wrap()
      |> Enum.reject(&(&1 == ""))
      |> List.first()

  defp transform(elements) when is_list(elements) do
    if is_text_list?(elements) do
      Enum.join(elements, " ")
    else
      Enum.into(without_nil(elements), %{}, &transform/1)
    end
  end

  defp transform({[type: "array"], elements}),
    do: Enum.map(without_nil(elements), &elem(transform(&1), 1))

  defp transform({[type: "collection"], elements}),
    do: Enum.map(only_collection(elements), &elem(transform(&1), 1))

  defp transform({name, [type: "integer"], [value]}), do: {name, String.to_integer(value)}

  defp transform({name, [type: "array"], elements}),
    do: {name, Enum.map(without_nil(elements), &elem(transform(&1), 1))}

  defp transform({name, [type: "boolean"], [value]}), do: {name, value == "true"}

  defp transform({name, [nil: "true"], []}), do: {name, nil}

  defp transform({name, _, [value]}), do: {name, value}

  defp transform({name, _, []}), do: {name, ""}

  defp transform({name, _, values}), do: {name, transform(values)}

  defp is_text_list?([last]) when is_binary(last), do: true
  defp is_text_list?([hd | rest]) when is_binary(hd), do: is_text_list?(rest)
  defp is_text_list?(_), do: false

  defp without_nil(list), do: Enum.reject(list, &is_nil/1)

  defp only_collection(elements),
    do:
      elements
      |> without_nil()
      |> Enum.reject(fn {_, value, _} -> value != [] end)
end
