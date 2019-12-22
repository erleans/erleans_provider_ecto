# ErleansProviderEcto

![](https://github.com/erleans/erleans_provider_ecto/workflows/ErleansProviderEcto%20tests/badge.svg)

This library implements the [Erleans](https://github.com/erleans/erleans) provider behaviour with Ecto. A schema that represents a grain is provided and the module `ErleansProviderEcto` is the provider behaviour implementation.

Users must create the Ecto Repo for the grains themselves. 

A migration is provided that can be used for a SQL database.

See the [Erleans Elixir Example](https://github.com/erleans/erleans_elixir_example) for an example of using this provider with Erleans.
