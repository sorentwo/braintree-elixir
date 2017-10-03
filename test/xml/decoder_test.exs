defmodule Braintree.XML.DecoderTest do
  use ExUnit.Case, async: true

  doctest Braintree.XML.Decoder

  import Braintree.XML.Decoder, only: [load: 1]

  describe "load/1" do
    test "with an empty string" do
      assert load("") == %{}
    end

    test "with simple values" do
      assert load("<customer><company>Soren</company><name>Parker</name></customer>") ==
        %{"customer" => %{"company" => "Soren", "name" => "Parker"}}
    end

    test "with typed values" do
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

    test "with a top level array" do
      xml = """
        <plans type="array">
          <plan>
            <id type="integer">1</id>
            <merchant-id type="integer">2</merchant-id>
          </plan>
          <plan>
            <id type="integer">2</id>
            <merchant-id type="integer">2</merchant-id>
          </plan>
        </plans>
      """

    assert load(xml) == %{"plans" => [
        %{"id" => 1, "merchant_id" => 2},
        %{"id" => 2, "merchant_id" => 2}
      ]}
    end

    test "with a top level collection" do
      xml = """
        <customers type="collection">
          <current-page-number type="integer">1</current-page-number>
          <page-size type="integer">50</page-size>
          <total-items type="integer">2</total-items>
          <customer>
            <id>1</id>
            <first-name>Jenna</first-name>
          </customer>
          <customer>
            <id>2</id>
            <first-name>Jenna</first-name>
          </customer>
        </customers>
      """

      assert load(xml) == %{"customers" => [
          %{"id" => "1", "first_name" => "Jenna"},
          %{"id" => "2", "first_name" => "Jenna"}
        ],
      }
    end
  end
end
