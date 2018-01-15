defmodule Braintree.Testing.Nonces do
  @moduledoc """
  A collection of static payment nonces provided to simplify testing server
  side code.

  Nonces are preferred over credit card numbers when testing payment methods.
  Only a subset of nonces are defined here, for the full list see the sandbox
  documentation about [payment method nonces][pmn].

  [pmn]: https://developers.braintreepayments.com/reference/general/testing/ruby#payment-method-nonces
  """
  def transactable do
    "fake-valid-nonce"
  end

  def consumed do
    "fake-consumed-nonce"
  end

  def paypal_future_payment do
    "fake-paypal-billing-agreement-nonce"
  end

  def apple_pay_visa do
    "fake-apple-pay-visa-nonce"
  end

  def apple_pay_master_card do
    "fake-apple-pay-mastercard-nonce"
  end

  def apple_pay_am_ex do
    "fake-apple-pay-amex-nonce"
  end

  def abstract_transactable do
    "fake-abstract-transactable-nonce"
  end

  def coinbase do
    "fake-coinbase-nonce"
  end
end
