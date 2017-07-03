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
      },
      "transaction" => %{
        "currency_iso_code" => "USD",
        "payment_instrument_type" => "paypal_account",
        "processor_response_code" => "2000",
        "processor_response_text" => "Do Not Honor",
        "status" => "processor_declined"
      }
    }

    error_response = ErrorResponse.construct(response)

    assert error_response.message == "CVV is required."
    refute error_response.errors == %{}

    refute error_response.params == %{}
    assert error_response.params[:customer]

    refute error_response.transaction == %{}
    assert error_response.transaction[:processor_response_code]
  end
end
