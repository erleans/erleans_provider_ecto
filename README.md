# ErleansProviderEcto

This library implements the [Erleans](https://github.com/erleans/erleans) provider behaviour with Ecto. A schema that represents a grain is provided and the module `ErleansProviderEcto` is the provider behaviour implementation.

Users must create the Ecto Repo for the grains themselves. 

A migration is provided that can be used for a SQL database.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `erleans_provider_ecto` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:erleans_provider_ecto, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/erleans_provider_ecto](https://hexdocs.pm/erleans_provider_ecto).

