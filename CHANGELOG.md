## v0.7.0 2016-09-20

### Enhancements

* [Braintree.ClientToken] Set the default client token version to `2`.
* [Braintree.Discount] Add support for discounts
* [Braintree.AddOn] Add support for add-ons
* [Braintree.SettlementBatchSummary] Add support for settlement reports
* [Braintree.Subscription] Support updating with `update/2`
* [Braintree.Subscription] Convert add-on and transaction lists to structs

### Changes

* [Braintree.XML] Strictly accept maps for generation, not keyword lists.

### Bug Fixes

* [Braintree.XML] Correctly handle decoding entities such as `&amp;`, `&gt;`
  and `&lt;`.
* [Braintree.XML] Fix encoding XML array values
* [Braintree.XML] Add encoding of binaries

## v0.6.0 2016-08-10

### Enhancements

* [Braintree.HTTP] Remove dependency on HTTPoison! Instead Hackney is used
  directly.
* [Braintree.HTTP] Configuration options can be provided for Hackney via
  `http_options`.
* [Braintree] Support `{:system, VAR}` for configs
* [Braintree.XML] Support for parsing top level arrays. Some endpoints, notably
  `plans`, may return an array rather than an object
* [Braintree.Plan] Added module and `all/0` for retrieving billing plans
* [Braintree.Customer] Enhanced with `find/1`
* [Braintree.Subscription] Enhanced with `cancel/1` and `retry_charge/1`

### Bug Fixes

* [Braintree.XML.Entity] XML entities are automatically encoded and decoded.
  This prevents errors when values contain quotes, ampersands, or other
  characters that must be escaped
* [Braintree.Customer] Return a tagged error tuple for `delete/1`
* [Braintree.Transaction] Use the correct `paypal` field for `Transaction` responses

## v0.5.0 2016-06-13

* Added: Paypal endpoints for use with the vault flow [TylerCain]
* Added: Construct Paypal accounts from customer responses
* Added: Support `submit_for_settlement/2` to Transaction
* Added: Typespec for the Transaction struct
* Fixed: Typespec for the CreditCard struct
* Fixed: Include xmerl in the list of applications to ensure that it is packaged
  with `exrm` releases.

## v0.4.0 2016-04-20

* Added: Available only during testing, `TestTransaction`, which can be used to
  transition transactions to different states.
* Added: Add `find`, `void`, and `refund` on `Transaction`. [Tyler Cain]
* Added: Add support for `PaymentMethod`, `PaymentMethodNonce`. [Tyler Cain]
* Added: Basic support for subscription management, starting with `create`.
  [Ryan Bigg]

## v0.3.2 2016-02-26

* Fixed: Log unprocessable responses rather than inspecting them to STDOUT.
* Fixed: Convert 404 and 401 responses to error tuples, they are common problems
  with misconfiguration.

## v0.3.1 2016-02-18

* Fixed: Lookup the certfile path at runtime rather than compile time. This
  fixes potential build errors when pre-building releases or packaging on
  platforms like Heroku.

## v0.3.0 2016-02-17

* Fixed: Raise helpful errors when missing required config
* Added: Client token module for generating new client tokens [Taylor Briggs]

## v0.2.0 2016-02-05

* Added: Support for updating and deleting customers.
* Added: A `Nonces` module for help testing transactions.
* Changed: Include testing support `Braintree.Testing.CreditCardNumbers` as well as
  `Braintree.Testing.Nonces` in `lib/testing`, making it available in packaged
  releases.
* Fixed: Trying to call `XML.load` on empty strings returns an empty map.
* Removed: The `__using__` macro has been removed from HTTP because the naming
  conflicted with `delete` actions. An equivalent macro will be introduced in
  the future.

## v0.1.0 2016-02-03

* Initial release with support for `Customer.create` and `Transaction.sale`.
