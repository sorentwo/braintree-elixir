[![Build Status](https://travis-ci.org/sorentwo/braintree-elixir.svg?branch=master)](https://travis-ci.org/sorentwo/braintree-elixir)

# Braintree

A native [Braintree][braintree] client library for Elixir. Only a subset of the
API is supported and this is a work in progress. That said, it is production
ready and any modules that have been implemented can be used.

[braintree]: http://braintree.com

## Installation

Add braintree to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:braintree, "~> 0.6"}]
end
```

Once that is configured you are all set. Braintree is a library, not an
application, but it does rely on `hackney`, which must be started:

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

You can optionally [configure Hackney options][opts] with:

```elixir
config :braintree,
  http_options: [
    timeout: 8000,     # default, in milliseconds
    recv_timeout: 5000 # default, in milliseconds
  ]
```

[opts]: https://github.com/benoitc/hackney/blob/master/doc/hackney.md#request5

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

[doc]: https://developers.braintreepayments.com/

## Testing

You'll need a Braintree sandbox account to run the integration tests. Also, be
sure that your account has [Duplicate Transaction Checking][dtc] disabled.

Your environment needs to have the following:
- Add-ons with ids: "bronze", "silver" and "gold"
- Plans with ids: "starter", "business"
- "business" plan needs to include the following Add-ons: "bronze" and "silver"

[dtc]: https://articles.braintreepayments.com/control-panel/transactions/duplicate-checking

## License

MIT License, see [LICENSE.txt](LICENSE.txt) for details.
