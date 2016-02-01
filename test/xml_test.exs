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

  test "load/1 with separated values" do
    assert load("<customer><company-name>Soren</company-name></customer>") ==
      %{"customer" => %{"company_name" => "Soren"}}
  end
end
