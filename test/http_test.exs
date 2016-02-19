defmodule Braintree.HTTPTest do
  use ExUnit.Case, async: true

  alias Braintree.{ConfigError, HTTP}

  test "process_url/1 prepends the endpoint" do
    merchant_id = Application.get_env(:braintree, :merchant_id)

    assert HTTP.process_url("customer") =~
      "sandbox.braintreegateway.com/merchants/#{merchant_id}/customer"
  end

  test "process_url/1 raises a helpful error message without config" do
    assert_config_error :merchant_id, fn ->
      HTTP.process_url("customer")
    end
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

  test "process_request_headers/1 raises a helpful error message" do
    assert_config_error :public_key, fn ->
      HTTP.process_request_headers([])
    end
  end

  test "process_response/1 converts a error status into errors" do
    assert HTTP.process_response({:ok, %{status_code: 401}}) == {:error, :unauthorized}
    assert HTTP.process_response({:ok, %{status_code: 404}}) == {:error, :not_found}
  end

  test "basic_auth/2 encodes credentials" do
    assert HTTP.basic_auth("432a04a551424c2b4177d76e252e991efd12ce4e", "e1d7d9be3817565444c8b9b90ad3ef2f3eb28c0c") ==
      "Basic NDMyYTA0YTU1MTQyNGMyYjQxNzdkNzZlMjUyZTk5MWVmZDEyY2U0ZTplMWQ3ZDliZTM4MTc1NjU0NDRjOGI5YjkwYWQzZWYyZjNlYjI4YzBj"
  end

  defp compress(string), do: :zlib.gzip(string)

  defp assert_config_error(key, fun) do
    value = Application.get_env(:braintree, key)

    try do
      Application.put_env(:braintree, key, nil)
      assert_raise ConfigError, "missing config for :#{key}", fun
    after
      Application.put_env(:braintree, key, value)
    end
  end
end
