use Mix.Config

config :braintree,
  merchant_id: System.get_env("BRAINTREE_MERCHANT_ID"),
  public_key: System.get_env("BRAINTREE_PUBLIC_KEY"),
  private_key: System.get_env("BRAINTREE_PRIVATE_KEY")

try do
  import_config "#{Mix.env}.secret.exs"
rescue
  Mix.Config.LoadError -> IO.puts "No secret file for #{Mix.env}"
end
