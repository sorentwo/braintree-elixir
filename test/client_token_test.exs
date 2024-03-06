defmodule Braintree.ClientTokenTest do
  # Don't test asynchronously in this file. It relies on Bypass.
  use ExUnit.Case

  import Braintree.Test.Support.ConfigHelper

  alias Braintree.{ClientToken, ErrorResponse}

  @error_gzip :zlib.gzip("""
              <?xml version="1.0" encoding="UTF-8"?>
              <api-error-response>
                <message>Test Error.</message>
              </api-error-response>
              """)

  describe "generate/1" do
    test "returns an ErrorResponse when the API responds with 422" do
      bypass = Bypass.open()

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 422, @error_gzip)
      end)

      with_applicaton_config(:sandbox_endpoint, "localhost:#{bypass.port}/", fn ->
        assert {
                 :error,
                 %ErrorResponse{message: "Test Error."}
               } = ClientToken.generate()
      end)
    end

    test "returns an error tuple with a code when the response is not 200 or 422" do
      bypass = Bypass.open()

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 500, "Something went wrong")
      end)

      with_applicaton_config(:sandbox_endpoint, "localhost:#{bypass.port}/", fn ->
        assert {:error, :server_error} = ClientToken.generate()
      end)
    end

    test "returns an error tuple with a code when the connection fails" do
      bypass = Bypass.open()
      Bypass.down(bypass)

      with_applicaton_config(:sandbox_endpoint, "localhost:#{bypass.port}/", fn ->
        assert {:error, :econnrefused} = ClientToken.generate()
      end)
    end
  end
end
