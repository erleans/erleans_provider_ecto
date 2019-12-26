# ErleansProviderEcto

![](https://github.com/erleans/erleans_provider_ecto/workflows/ErleansProviderEcto%20tests/badge.svg)

This library implements the [Erleans](https://github.com/erleans/erleans) provider behaviour with [Ecto](https://github.com/elixir-ecto/ecto). A schema that represents a grain is provided and the module `ErleansProviderEcto` is the provider behaviour implementation.

Users must create the Ecto Repo for the grains themselves. 

A migration is provided that can be used for a SQL database.

See the [Erleans Elixir Example](https://github.com/erleans/erleans_elixir_example) for an example of using this provider with Erleans.

# Example Configuration

Configuring a Postgres Erleans provider named `:postgres` and setting it to the default provider:

``` elixir
config :erleans,
  providers: %{
    :postgres => %{
      :module => ErleansProviderEcto.Postgres,
      :args => [
        {:database, "testdb"},
        {:username, "test"},
        {:hostname, "localhost"}
      ]
    }
  },
  default_provider: :postgres
```

# How It Works

`ErleansProviderEcto` uses [Ecto's dynamic repo](https://hexdocs.pm/ecto/replicas-and-dynamic-repositories.html#dynamic-repositories) support so when booting Erleans can start up any configured providers the user configures, which may or may not use the same Repo module, and ensure they are connected before being used by any grains.

The dynamic `repo` is given the same name as the Erleans provider. So when the above configuration is used therepo will be named `:postgres`.
