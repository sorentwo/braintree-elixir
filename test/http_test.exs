defmodule Braintree.HTTPTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  alias Braintree.{ConfigError, HTTP}

  test "build_url/1 prepends the endpoint" do
    merchant_id = Braintree.get_env(:merchant_id)

    assert HTTP.build_url("customer") =~
      "sandbox.braintreegateway.com/merchants/#{merchant_id}/customer"
  end

  test "build_url/1 raises a helpful error message without config" do
    assert_config_error :merchant_id, fn ->
      HTTP.build_url("customer")
    end
  end

  test "encode_body/1 converts the request body to xml" do
    params = %{company: "Soren", first_name: "Parker"}

    assert HTTP.encode_body(params) ==
      ~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company>Soren</company>\n<first-name>Parker</first-name>|
  end

  test "encode_body/1 ignores empty bodies" do
    assert HTTP.encode_body("") == ""
    assert HTTP.encode_body(%{}) == ""
  end

  test "decode_body/1 converts the request back from xml" do
    xml = compress(~s|<?xml version="1.0" encoding="UTF-8" ?>\n<company><name>Soren</name></company>|)

    assert HTTP.decode_body(xml) ==
      %{"company" => %{"name" => "Soren"}}
  end

  test "decode_body/1 safely handles empty responses" do
    assert HTTP.decode_body(compress("")) == %{}
    assert HTTP.decode_body(compress(" ")) == %{}
  end

  test "decode_body/1 logs unhandled errors" do
    assert capture_log(fn ->
      HTTP.decode_body("asdf")
    end) =~ "unprocessable response"
  end

  test "basic_auth/2 encodes credentials" do
    assert HTTP.basic_auth("432a04a551424c2b4177d76e252e991efd12ce4e", "e1d7d9be3817565444c8b9b90ad3ef2f3eb28c0c") ==
      "Basic NDMyYTA0YTU1MTQyNGMyYjQxNzdkNzZlMjUyZTk5MWVmZDEyY2U0ZTplMWQ3ZDliZTM4MTc1NjU0NDRjOGI5YjkwYWQzZWYyZjNlYjI4YzBj"
  end

  test "build_options/0 considers the application environment" do
    Application.put_env(:braintree, :http_options, [timeout: 9000])

    options = HTTP.build_options

    assert :with_body in options
    assert {:timeout, 9000} in options
  end

  defp compress(string), do: :zlib.gzip(string)

  defp assert_config_error(key, fun) do
    value = Application.get_env(:braintree, key)

    try do
      Application.delete_env(:braintree, key)
      assert_raise ConfigError, "missing config for :#{key}", fun
    after
      Application.put_env(:braintree, key, value)
    end
  end
end
