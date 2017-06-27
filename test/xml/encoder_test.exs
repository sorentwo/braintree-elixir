defmodule Braintree.XML.EncoderTest do
  use ExUnit.Case, async: true

  doctest Braintree.XML.Encoder

  import Braintree.XML.Encoder, only: [dump: 1]

  describe "dump/1" do
    test "with content" do
      assert dump(%{company: "Soren", first_name: "Parker"}) ==
        ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company>Soren</company>\n<first-name>Parker</first-name>|
    end

    test "with children" do
      assert dump(%{company: "Soren", nested: %{name: "Parker"}}) ==
        ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company>Soren</company>\n<nested>\n<name>Parker</name>\n</nested>|

      assert dump(%{company: "Soren", nested: [%{name: "Parker"}, %{name: "Shannon"}]}) ==
        ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company>Soren</company>\n<nested>\n<name>Parker</name>\n<name>Shannon</name>\n</nested>|
    end
  end
end
