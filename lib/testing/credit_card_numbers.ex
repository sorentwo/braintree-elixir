defmodule Braintree.Testing.CreditCardNumbers do
  @moduledoc """
  The functions contained in the Braintree.Testing.CreditCardNumbers module
  provide credit card numbers that should be used when working in the sandbox
  environment. The sandbox will not accept any credit card numbers other than
  the ones listed below.

  See http://www.braintreepayments.com/docs/ruby/reference/sandbox
  """

  def all do
    am_exes() ++
    carte_blanches() ++
    diners_clubs() ++
    discovers() ++
    jcbs() ++
    master_cards() ++
    unknowns() ++
    visas()
  end

  def am_exes do
    ~w(378282246310005 371449635398431 378734493671000)
  end

  def carte_blanches do
    ~w(30569309025904)
  end

  def diners_clubs do
    ~w(38520000023237)
  end

  def discovers do
    ~w(6011111111111117 6011000990139424)
  end

  def jcbs do
    ~w(3530111333300000 3566002020360505)
  end

  def master_cards do
    ~w(5105105105105100 5555555555554444)
  end

  def unknowns do
    ~w(1000000000000008)
  end

  def visas do
    ~w(4009348888881881 4012888888881881 4111111111111111 4000111111111115 4500600000000061)
  end

  defmodule FailsSandboxVerification do
    @moduledoc """
    These are vendor specific numbers that will always fail verification.
    """

    def all do
      [am_ex(), discover(), master_card(), visa()]
    end

    def am_ex do
      "378734493671000"
    end

    def discover do
      "6011000990139424"
    end

    def master_card do
      "5105105105105100"
    end

    def visa do
      "4000111111111115"
    end
  end
end
