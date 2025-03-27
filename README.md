# Braintree

[![Build Status](https://travis-ci.org/sorentwo/braintree-elixir.svg?branch=master)](https://travis-ci.org/sorentwo/braintree-elixir)
[![Hex version](https://img.shields.io/hexpm/v/braintree.svg "Hex version")](https://hex.pm/packages/braintree)
[![Hex downloads](https://img.shields.io/hexpm/dt/braintree.svg "Hex downloads")](https://hex.pm/packages/braintree)
[![Inline docs](https://inch-ci.org/github/sorentwo/braintree-elixir.svg)](https://inch-ci.org/github/sorentwo/braintree-elixir)

A native [Braintree][braintree] client library for Elixir.

[braintree]: https://www.braintreepayments.com

## Installation

Add braintree to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:braintree, "~> 0.13"}]
end
```

Once that is configured you are all set. Braintree is a library, not an
application, but it does rely on `hackney`, which must be started. For Elixir
versions < 1.4 you'll need to include it in the list of applications:

```elixir
def application do
  [applications: [:braintree]]
end
```

Within your application you will need to configure the merchant id and
authorization keys. You do *not* want to put this information in your
`config.exs` file! Either put it in a `{prod,dev,test}.secret.exs` file which is
sourced by `config.exs`, or read the values in from the environment in
`runtime.exs`:

```elixir
config :braintree,
  environment: :sandbox,
  master_merchant_id: System.fetch_env!("BRAINTREE_MASTER_MERCHANT_ID"),
  merchant_id: System.fetch_env!("BRAINTREE_MERCHANT_ID"),
  public_key:  System.fetch_env!("BRAINTREE_PUBLIC_KEY"),
  private_key: System.fetch_env!("BRAINTREE_PRIVATE_KEY")
```

Furthermore, the environment defaults to `:sandbox`, so you'll want to configure
it with `:production` in `prod.exs`.

Braintree has certificates that will be used for verification during the HTTP
request. This library includes them and will use them by default, but if you
need to override them, you may provide the configuration `:cacertfile` and
`:sandbox_cacertfile`.

You may optionally pass directly those configuration keys to all functions
performing an API call. In that case, those keys will be used to perform the
call.

You can optionally [configure Hackney options][opts] with:

```elixir
config :braintree,
  http_options: [
    timeout: 30_000, # default, in milliseconds
    recv_timeout: 5000 # default, in milliseconds
  ]
```

[opts]: https://hexdocs.pm/hackney/hackney.html#request/5

## Usage

The online [documentation][doc] for Ruby/Java/Python etc. will give you a
general idea of the modules and available functionality. Where possible the
namespacing has been preserved.

The CRUD functions for each action module break down like this:

```elixir
alias Braintree.Customer
alias Braintree.ErrorResponse, as: Error

case Customer.create(%{company: "Whale Corp"}) do
  {:ok, %Customer{} = customer} -> do_stuff_with_customer(customer)
  {:error, %Error{} = error}    -> do_stuff_with_error(error)
end
```

### Searching

Search params are constructed with a fairly complex structure of maps. There
isn't a DSL provided, so queries must be constructed by hand. For example, to
search for a customer:

```elixir
search_params = %{
  first_name: %{is: "Jenna"},
  last_name: %{
    starts_with: "Smith",
    contains: "ith",
    is_not: "Smithsonian"
  },
  email: %{ends_with: "gmail.com"}
}

{:ok, customers} = Braintree.Customer.search(search_params)
```

Or, to search for pending credit card verifications within a particular dollar
amount:

```elixir
search_params = %{
  amount: %{
    min: "10.0",
    max: "15.0"
  },
  status: ["approved", "pending"]
}

{:ok, verifications} = Braintree.CreditCardVerification.search(search_params)
```

[doc]: https://developers.braintreepayments.com/


### Telemetry

If the `telemetry` application is running, the library will emit telemetry events.

Immediately before the HTTP request is fired, a start event will be fired with the following shape:

```
 event name:    [:braintree, :request, :start]
 measurements:  %{system_time: System.system_time()}
 meta data:     %{method: method, path: path}
```

Once the HTTP call completes, a stop event will be fired with the following shape:

```
 event name:    [:braintree, :request, :stop]
 measurements:  %{duration: duration}
 meta data:     %{method: method, path: path, http_status: status}
```

If Hackney returns an error, an error event will be fired with the following shape:

```
 event name:    [:braintree, :request, :error]
 measurements:  %{duration: duration}
 meta data:     %{method: method, path: path, error: error_reason}
```

If an exception is raised during the Hackney call, an exception event will be fired with the following shape:

```
 event name:    [:braintree, :request, :exception]
 measurements:  %{duration: duration}
 meta data:     %{method: method, path: path, kind: error_type, reason: error_message, stacktrace: stacktrace}
```

## Testing

You'll need a Braintree sandbox account to run the integration tests. Also, be
sure that your account has [Duplicate Transaction Checking][dtc] disabled.

### Merchant Account Features

In order to test the merchant account features, your sandbox account needs to
have a master merchant account and it needs to be added to your environment
variables (only needed in test).

Your environment needs to have the following:

* Add-ons with ids: "bronze", "silver" and "gold"
* Plans with ids: "starter", "business"
* "business" plan needs to include the following add-ons: "bronze" and "silver"

### PayPal Account Testing

PayPal testing uses the mocked API flow, which requires linking a sandbox PayPal
account. You can accomplish that by following the directions for [linked paypal
testing][plp].

[dtc]: https://articles.braintreepayments.com/control-panel/transactions/duplicate-checking
[plp]: https://developers.braintreepayments.com/guides/paypal/testing-go-live/php#linked-paypal-testing

### Testing Using Only `localhost`

You can optionally configure the sandbox endpoint url to point towards a local url and
port for testing which does not need to call out to the Braintree sandbox API.
For example, in your `config.exs`

```elixir
config :braintree, :sandbox_endpoint, "localhost:4001"
```

In conjuction with a libary such as [`Bypass`](https://github.com/PSPDFKit-labs/bypass)
you can use this config to define test-specific returns from `Braintree` calls without
hitting the Braintree sandbox API.

## License

MIT License, see [LICENSE.txt](LICENSE.txt) for details.
