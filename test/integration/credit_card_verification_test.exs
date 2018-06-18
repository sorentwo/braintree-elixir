defmodule Braintree.Integration.CreditCardVerificationTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  alias Braintree.{CreditCardVerification, Customer, PaymentMethod}

  describe "search/1" do
    test "with valid params" do
      {:ok, customer} = Customer.create(%{first_name: "Waldo", last_name: "Smith"})

      {:ok, _payment_method} =
        PaymentMethod.create(%{
          customer_id: customer.id,
          payment_method_nonce: Braintree.Testing.Nonces.transactable(),
          options: %{
            verify_card: true,
            verification_amount: "45.3"
          }
        })

      search_params = %{customer_id: %{is: customer.id}}

      assert {:ok, [%CreditCardVerification{} = verification | _]} =
               CreditCardVerification.search(search_params)

      assert verification.amount == "45.30"
    end

    test "returns not found" do
      assert {:error, :not_found} = CreditCardVerification.search(%{customer_id: %{is: "Surly"}})
    end
  end
end
