defmodule Braintree.XML.EncoderTest do
  use ExUnit.Case, async: true

  doctest Braintree.XML.Encoder

  import Braintree.XML.Encoder, only: [dump: 1]

  @xml_tag ~s|<?xml version="1.0" encoding="UTF-8" ?>|

  describe "dump/1" do
    test "with content" do
      assert [xml_tag | nodes] =
               %{company: "Soren", first_name: "Parker"}
               |> dump()
               |> String.split("\n")

      # Order isn't guaranteed when iterating on a map.
      assert xml_tag == @xml_tag
      assert ~s|<company>Soren</company>| in nodes
      assert ~s|<first-name>Parker</first-name>| in nodes
    end

    test "with children" do
      assert [xml_tag | nodes] =
               %{company: "Soren", nested: %{name: "Parker"}}
               |> dump()
               |> String.split("\n")

      assert xml_tag == @xml_tag

      assert nodes == ~w[<company>Soren</company> <nested> <name>Parker</name> </nested>] or
               nodes == ~w[<nested> <name>Parker</name> </nested> <company>Soren</company>]

      assert [xml_tag | nodes] =
               %{company: "Soren", nested: [%{name: "Parker"}, %{name: "Shannon"}]}
               |> dump()
               |> String.split("\n")

      assert xml_tag == @xml_tag

      assert nodes in [
               [
                 "<company>Soren</company>",
                 ~s|<nested type="array">|,
                 "<item>",
                 "<name>Parker</name>",
                 "</item>",
                 "<item>",
                 "<name>Shannon</name>",
                 "</item>",
                 "</nested>"
               ],
               [
                 ~s|<nested type="array">|,
                 "<item>",
                 "<name>Parker</name>",
                 "</item>",
                 "<item>",
                 "<name>Shannon</name>",
                 "</item>",
                 "</nested>",
                 "<company>Soren</company>"
               ]
             ]

      assert [xml_tag | nodes] =
               %{company: "Soren", pets: ["cat", "dog"]}
               |> dump()
               |> String.split("\n")

      assert xml_tag == @xml_tag

      assert nodes in [
               [
                 "<company>Soren</company>",
                 ~s|<pets type="array">|,
                 "<item>",
                 "cat",
                 "</item>",
                 "<item>",
                 "dog",
                 "</item>",
                 "</pets>"
               ],
               [
                 ~s|<pets type="array">|,
                 "<item>",
                 "cat",
                 "</item>",
                 "<item>",
                 "dog",
                 "</item>",
                 "</pets>",
                 "<company>Soren</company>"
               ]
             ]
    end
  end
end
