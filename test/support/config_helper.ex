defmodule Braintree.Test.Support.ConfigHelper do
  @moduledoc false

  def with_applicaton_config(key, value, fun) do
    original = Braintree.get_env(key, :none)

    try do
      Braintree.put_env(key, value)
      fun.()
    after
      case original do
        :none -> Application.delete_env(:braintree, key)
        _ -> Braintree.put_env(key, original)
      end
    end
  end
end
