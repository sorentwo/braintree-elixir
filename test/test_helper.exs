# Avoid running integration tests without the necessary configuration. This
# prevents running integration tests on CI, where the encrypted values may not
# be available.
unless Braintree.get_env(:merchant_id) do
  IO.puts("Missing configuration, skipping integration tests")

  ExUnit.configure(exclude: [:integration])
end

ExUnit.start()
