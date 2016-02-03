defmodule Braintree.ErrorResponseTest do
  use ExUnit.Case, async: true

  alias Braintree.ErrorResponse

  test "converting an api error response" do
    response = %{
      "errors" => %{
        "customer" => %{
          "credit_card" => %{
            "errors" => [
              %{"attribute" => "cvv", "code" => "81706", "message" => "CVV is required."}
            ]
          },
          "errors" => []
        }
      },
      "message" => "CVV is required.",
      "params" => %{
        "customer" => %{
          "credit_card" => %{
            "expiration_date" => "01/2016",
            "options" => %{
              "verify_card" => "true"
            }
          }
        }
      }
    }

    error_response = ErrorResponse.construct(response)

    assert error_response.message == "CVV is required."
    refute error_response.params == %{}
    refute error_response.errors == %{}
  end
end
