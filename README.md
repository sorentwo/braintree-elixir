[![Build Status](https://travis-ci.org/sorentwo/braintree-elixir.svg?branch=master)](https://travis-ci.org/sorentwo/braintree-elixir)

# Braintree

A native [Braintree][braintree] client library for Elixir. Only a subset of the
API is supported and this is a work in progress. That said, it is production
ready and any modules that have been implemented can be used.

## Installation

Add braintree to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:braintree, "~> 0.0.1"}]
end
```

Once that is configured you are all set. Braintree is a library, not an
application, but it does rely on `HTTPoison`, which must be started.

```elixir
def application do
  [applications: [:braintree]]
end
```

Within your application you will need to configure the merchant id and
authorization keys. You do *not* want to put this information in your
`config.exs` file! Either put it in a `{prod,dev,test}.secret.exs` file which is
sourced by `config.exs`, or read the values in from the environment:

```elixir
config :braintree,
  environment: :sandbox,
  merchant_id: System.get_env("BRAINTREE_MERCHANT_ID"),
  public_key:  System.get_env("BRAINTREE_PUBLIC_KEY"),
  private_key: System.get_env("BRAINTREE_PRIVATE_KEY")
```

Furthermore, the environment defaults ot `:sandbox`, so you'll want to configure
it with `:production` in `prod.exs`.

You can optionally configure HTTPoison timeouts with:

```elixir
config :braintree,
  timeout: 8000,     # default, in milliseconds
  recv_timeout: 5000 # default, in milliseconds
```

## Usage

The online [documentation][doc] for Ruby/Java/Python etc. will give you a
general idea of the modules and available functionality. Where possible, which
is everywhere so far, the namespacing has been matched.

The CRUD functions for each action module break down like this:

```elixir
alias Braintree.Customer
alias Braintree.ErrorResponse, as: Error

case Customer.create(%{company: "Whale Corp"}) do
  {:ok, %Customer{} = customer} -> do_stuff_with_customer(customer)
  {:error, %Error{} = error}    -> do_stuff_with_error(error)
end
```

## License

MIT License, see [LICENSE.txt](LICENSE.txt) for details.

[braintree]: http://braintree.com
[doc]: https://developers.braintreepayments.com/
