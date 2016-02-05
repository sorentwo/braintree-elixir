defmodule Braintree.HTTPTest do
  use ExUnit.Case, async: true

  alias Braintree.HTTP

  test "process_url/1 prepends the endpoint" do
    merchant_id = Application.get_env(:braintree, :merchant_id)

    assert HTTP.process_url("customer") =~
      "sandbox.braintreegateway.com/merchants/#{merchant_id}/customer"
  end

  test "process_request_body/1 converts the request body to xml" do
    params = %{company: "Soren", first_name: "Parker"}

    assert HTTP.process_request_body(params) ==
      ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company>Soren</company>\n<first-name>Parker</first-name>|
  end

  test "process_request_body/1 ignores empty bodies" do
    assert HTTP.process_request_body("") == ""
    assert HTTP.process_request_body(%{}) == ""
  end

  test "process_response_body/1 converts the request back from xml" do
    xml = compress(~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company><name>Soren</name></company>|)

    assert HTTP.process_response_body(xml) ==
      %{"company" => %{"name" => "Soren"}}
  end

  test "process_response_body/1 safely handles empty responses" do
    assert HTTP.process_response_body(compress("")) == %{}
    assert HTTP.process_response_body(compress(" ")) == %{}
  end

  test "basic_auth/2 encodes credentials" do
    assert HTTP.basic_auth("432a04a551424c2b4177d76e252e991efd12ce4e", "e1d7d9be3817565444c8b9b90ad3ef2f3eb28c0c") ==
      "Basic NDMyYTA0YTU1MTQyNGMyYjQxNzdkNzZlMjUyZTk5MWVmZDEyY2U0ZTplMWQ3ZDliZTM4MTc1NjU0NDRjOGI5YjkwYWQzZWYyZjNlYjI4YzBj"
  end

  defp compress(string), do: :zlib.gzip(string)
end
