defmodule Braintree.Testing.Nonces do
  @moduledoc """
  The functions contained in this module provide pre-defined nonces that can
  be used when working with the sandbox. Nonces are preferred over credit
  card numbers when testing payment methods.

  See http://www.braintreepayments.com/docs/ruby/reference/sandbox
  """
  def transactable do
    "fake-valid-nonce"
  end

  def consumed do
    "fake-consumed-nonce"
  end

  def paypal_one_time_payment do
    "fake-paypal-one-time-nonce"
  end

  def paypal_future_payment do
    "fake-paypal-future-nonce"
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
