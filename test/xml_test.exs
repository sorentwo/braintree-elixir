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

  test "load/1 with an empty string" do
    assert load("") == %{}
  end

  test "load/1 with simple values" do
    assert load("<customer><company>Soren</company><name>Parker</name></customer>") ==
      %{"customer" => %{"company" => "Soren", "name" => "Parker"}}
  end

  test "load/1 with top level array" do
    xml = """
      <plans type="array">
        <plan>
            <id>1</id>
            <merchant-id>2</merchant-id>
            <billing-day-of-month nil="true"/>
            <billing-frequency type="integer">1</billing-frequency>
            <currency-iso-code>USD</currency-iso-code>
            <description>Simple Plan</description>
            <name>Simple Plan</name>
            <number-of-billing-cycles nil="true"/>
            <price>24.99</price>
            <trial-duration nil="true"/>
            <trial-duration-unit nil="true"/>
            <trial-period type="boolean">false</trial-period>
            <created-at type="datetime">2016-07-07T01:49:36Z</created-at>
            <updated-at type="datetime">2016-07-07T01:49:36Z</updated-at>
            <add-ons type="array"/>
            <discounts type="array"/>
        </plan>
        <plan>
            <id>1</id>
            <merchant-id>2</merchant-id>
            <billing-day-of-month nil="true"/>
            <billing-frequency type="integer">1</billing-frequency>
            <currency-iso-code>USD</currency-iso-code>
            <description>Simple Plan</description>
            <name>Simple Plan</name>
            <number-of-billing-cycles nil="true"/>
            <price>24.99</price>
            <trial-duration nil="true"/>
            <trial-duration-unit nil="true"/>
            <trial-period type="boolean">false</trial-period>
            <created-at type="datetime">2016-07-07T01:49:36Z</created-at>
            <updated-at type="datetime">2016-07-07T01:49:36Z</updated-at>
            <add-ons type="array"/>
            <discounts type="array"/>
        </plan>
      </plans>
    """

    assert load(xml) == %{
      "plans" => [
        %{
          "add_ons" => [],
          "billing_day_of_month" => nil,
          "billing_frequency" => 1,
          "created_at" => "2016-07-07T01:49:36Z",
          "currency_iso_code" => "USD",
          "description" => "Simple Plan",
          "discounts" => [], "id" => "1",
          "merchant_id" => "2",
          "name" => "Simple Plan",
          "number_of_billing_cycles" => nil,
          "price" => "24.99",
          "trial_duration" => nil,
          "trial_duration_unit" => nil,
          "trial_period" => false,
          "updated_at" => "2016-07-07T01:49:36Z"
        }, %{
          "add_ons" => [],
          "billing_day_of_month" => nil,
          "billing_frequency" => 1,
          "created_at" => "2016-07-07T01:49:36Z",
          "currency_iso_code" => "USD",
          "description" => "Simple Plan",
          "discounts" => [],
          "id" => "1",
          "merchant_id" => "2",
          "name" => "Simple Plan",
          "number_of_billing_cycles" => nil,
          "price" => "24.99",
          "trial_duration" => nil,
          "trial_duration_unit" => nil,
          "trial_period" => false,
          "updated_at" => "2016-07-07T01:49:36Z"}
        ]}
  end

  test "load/1 with typed values" do
    xml = """
      <customer>
        <id type="integer">65854825</id>
        <first-name nil="true"/>
        <last-name nil="true"/>
        <created-at type="datetime">2016-02-02T18:36:33Z</created-at>
        <custom-fields/>
        <credit-cards type="array">
          <credit-card>
            <bin>510510</bin>
            <card-type>MasterCard</card-type>
            <default type="boolean">true</default>
            <expiration-month>01</expiration-month>
            <expiration-year>2016</expiration-year>
            <expired type="boolean">false</expired>
            <verifications type="array"/>
          </credit-card>
        </credit-cards>
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
        "credit_cards" => [
          %{"bin" => "510510",
            "card_type" => "MasterCard",
            "default" => true,
            "expiration_month" => "01",
            "expiration_year" => "2016",
            "expired" => false,
            "verifications" => []}
        ],
        "addresses" => []
      }
    }
  end
end
