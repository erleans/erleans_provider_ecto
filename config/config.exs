import Config

config :erleans_provider_ecto, ecto_repos: [ErleansProviderEcto.Repo]

import_config "#{Mix.env()}.exs"
