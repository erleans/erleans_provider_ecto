import Config

config :erleans_provider_ecto, ecto_repos: [ErleansProviderEcto.PostgresRepo]

import_config "#{Mix.env()}.exs"
