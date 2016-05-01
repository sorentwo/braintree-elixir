## v0.4.1 2016-05-1

* Added: `Braintree.Plan.all`. [David Salazar]

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
