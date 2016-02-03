defmodule Braintree.XMLTest do
  use ExUnit.Case, async: true

  doctest Braintree.XML

  import Braintree.XML, only: [load: 1, dump: 1]

  test "dump/1 with content" do
    assert dump(%{company: "Soren", first_name: "Parker"}) ==
      ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company>Soren</company>\n<first-name>Parker</first-name>|
  end

  test "dump/1 with children" do
    assert dump(%{company: "Soren", nested: %{name: "Parker"}}) ==
      ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company>Soren</company>\n<nested>\n<name>Parker</name>\n</nested>|

    assert dump(%{company: "Soren", nested: [%{name: "Parker"}, %{name: "Shannon"}]}) ==
      ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company>Soren</company>\n<nested>\n<name>Parker</name>\n<name>Shannon</name>\n</nested>|
  end

  test "load/1 with simple values" do
    assert load("<customer><company>Soren</company><name>Parker</name></customer>") ==
      %{"customer" => %{"company" => "Soren", "name" => "Parker"}}
  end

  test "load/1 with typed values" do
    xml = """
      <customer>
        <id type="integer">65854825</id>
        <first-name nil="true"/>
        <last-name nil="true"/>
        <created-at type="datetime">2016-02-02T18:36:33Z</created-at>
        <custom-fields/>
        <credit-cards type="array"/>
        <addresses type="array"/>
      </customer>
    """

    assert load(xml) == %{
      "customer" => %{
        "id" => 65854825,
        "first_name" => nil,
        "last_name" => nil,
        "created_at" => "2016-02-02T18:36:33Z",
        "custom_fields" => "",
        "credit_cards" => [],
        "addresses" => []
      }
    }
  end
end
