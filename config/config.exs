use Mix.Config

try do
  import_config "#{Mix.env}.secret.exs"
rescue
  Mix.Config.LoadError -> IO.puts "No secret file for #{Mix.env}"
end
